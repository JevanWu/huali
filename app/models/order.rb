# == Schema Information
#
# Table name: orders
#
#  address_id           :integer
#  adjustment           :string(255)
#  completed_at         :datetime
#  coupon_code_id       :integer
#  created_at           :datetime         not null
#  delivery_date        :date
#  expected_date        :date
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  kind                 :string(255)      default("normal"), not null
#  last_order           :string(255)
#  memo                 :text
#  merchant_order_no    :string(255)
#  payment_total        :decimal(8, 2)    default(0.0)
#  prechecked           :boolean
#  printed              :boolean          default(FALSE)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  ship_method_id       :integer
#  source               :string(255)      default(""), not null
#  special_instructions :text
#  state                :string(255)      default("ready")
#  subject_text         :text             default("")
#  total                :decimal(8, 2)    default(0.0), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#  validation_code      :string(255)
#
# Indexes
#
#  index_orders_on_identifier                  (identifier) UNIQUE
#  index_orders_on_merchant_order_no_and_kind  (merchant_order_no,kind)
#  index_orders_on_user_id                     (user_id)
#

require 'enumerize'
require 'state_machine'

class Order < ActiveRecord::Base
  belongs_to :address
  belongs_to :user
  # just for convenient meta-methods
  belongs_to :ship_method

  has_many :line_items, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :shipments, dependent: :destroy
  has_one :postcard, dependent: :destroy
  has_many :products, through: :line_items
  belongs_to :coupon_code_record, foreign_key: :coupon_code_id, class_name: 'CouponCode'
  has_many :refunds
  has_one :sync_orders
  has_one :instant_delivery


  extend Enumerize
  enumerize :kind, in: [:normal, :jd, :tencent, :xigua, :marketing, :customer,
    :taobao, :tmall, :b2b, :fieldschina, :offline, :yhd, :amazon, :dangdang], default: :normal

  delegate :province_name, :city_name, to: :address, allow_nil: true
  delegate :paymethod, to: :transaction, allow_nil: true
  delegate :province_id, :city_id, :area_id, to: :address, prefix: 'address', allow_nil: true

  before_validation :generate_identifier, on: :create

  validates_presence_of :identifier, :state, :total, :item_total
  validates :merchant_order_no, uniqueness: { scope: :kind }, allow_blank: true
  validates :merchant_order_no, presence: true, if: Proc.new { |order| ['taobao', 'tmall'].include?(order.kind) }

  after_validation :cal_item_total
  after_validation :cal_total, on: :create

  state_machine :state, initial: :generated do
    # TODO implement an auth_state dynamically for each state
    before_transition to: :completed, do: :complete_order
    after_transition to: :wait_confirm, do: :update_sold_total
    after_transition to: :wait_confirm, do: :reward_and_rebate_huali_point
    before_transition to: :wait_check, do: :sync_payment
    after_transition to: :wait_ship, do: :generate_shipment
    after_transition to: :refunded, do: :process_refund_huali_point
    after_transition to: :wait_make, do: :print_order
    after_transition to: :wait_check, do: :update_product_stock

    # use adj. for state with future vision
    # use v. for event name
    state :generated do
      transition to: :wait_check, on: :pay
      transition to: :void, on: :cancel
    end

    state :wait_check do
      validates_presence_of :payment_total

      transition to: :wait_make, on: :check
      transition to: :wait_refund, on: :cancel
    end

    state :wait_make do
      validates_presence_of :ship_method, :delivery_date
      transition to: :wait_ship, on: :make
      transition to: :wait_refund, on: :cancel
    end

    state :wait_ship do
      transition to: :wait_confirm, on: :ship
      transition to: :wait_refund, on: :cancel
    end

    state :wait_confirm do
      transition to: :completed, on: :confirm
      transition to: :wait_refund, on: :cancel
    end

    state :wait_refund do
      transition to: :refunded, on: :refund
    end
  end

  scope :yesterday, -> { where 'delivery_date = ?', Date.yesterday }
  scope :current, -> { where 'delivery_date = ?', Date.current }
  scope :tomorrow, -> { where 'delivery_date = ?', Date.tomorrow }
  scope :next_two_day, -> { where 'delivery_date = ?', Date.current.next_day(2) }
  scope :within_this_week, -> { where('delivery_date >= ? AND delivery_date <= ? ', Date.current.beginning_of_week, Date.current.end_of_week) }
  scope :within_this_month, -> { where('delivery_date >= ? AND delivery_date <= ? ', Date.current.beginning_of_month, Date.current.end_of_month) }
  scope :accountable, -> { where("kind = 'normal'").where("state != 'void' and state != 'generated'") }
  scope :in_day, lambda { |date| where("created_at >= ? and created_at < ?", date, date.tomorrow) }
  scope :unpaid_today, lambda { |hours_ago| in_day(Date.current).where(state: 'generated').where("created_at <= ?", hours_ago.hours.ago) }
  scope :ready_to_ship_today, lambda { |date| where(delivery_date: date).where('state NOT IN (?)', ['void', 'refunded']) }

  default_scope -> { order("created_at DESC") }

  # Queries
  class << self
    def by_number(number)
      where(number: number)
    end

    def between(start_date, end_date)
      where(created_at: start_date..end_date)
    end

    def by_state(state)
      where(state: state)
    end

    def complete
      where('completed_at IS NOT NULL')
    end

    def incomplete
      where(completed_at: nil)
    end

    def full_info(key)
      includes(:user, :address, :transactions, :shipments).find_by_id(key)
    end
  end

  attr_writer :coupon_code
  def coupon_code
    @coupon_code ||= coupon_code_record.try(:code)
  end

  def finished?
    ["completed", "refunded", "void"].include?(state)
  end

  def not_yet_shipped?
    state.in?(['generated', 'wait_check', 'wait_make'])
  end

  def generate_identifier
    self.identifier = uid_prefixed_by('OR')
    self.validation_code = self.identifier.gsub(/[a-zA-Z]*/, '').to_i.to_s(16)
  end

  def generate_transaction(opts, use_huali_point = false)
    need_to_pay = self.total > self.user.huali_point ? self.total - self.user.huali_point : 0
    default = {
      amount: use_huali_point ? need_to_pay : self.total,
      use_huali_point: !!use_huali_point,
      subject: subject_text,
      body: body_text,
      client_ip: user.current_sign_in_ip,
    }
    self.transactions.create default.merge(opts)
  end

  def complete_transaction(opts)
    # generate and process transaction
    t = generate_transaction(opts)
    t.start
    t.processed_at = Time.now
    t.complete
  end

  # options = {
    # tracking_num: String
    # ship_method_id: Integer
    # note: String
    # cost: Integer (optional)
  # }
  def generate_shipment
    self.shipments.create
  end

  def cal_item_total
    return unless state == 'wait_check' or state == 'generated'
    self.item_total = line_items.map(&:total).inject(:+).to_f
  end

  def cal_total
    self.total = self.item_total
  end

  def completed?
    !! completed_at
  end

  def checkout_allowed?
    line_items.count > 0
  end

  def cancel_allowed?
    state.in? ['generated', 'wait_check']
  end

  def item_discount?
    line_items.any? { |item| item.discount? }
  end

  def transaction_state
    transaction.state
  end

  def shipment_state
    shipment.state
  end

  def product_names
    products.map(&:name)
  end

  def category_names
    products.map(&:category_name)
  end

  def transaction
    transactions.where(state: 'completed').first || transactions.last
  end

  def shipment
    shipments.last
  end

  def body_text
    # prepare body text for transaction
  end

  def from_taobao?
    ['taobao', 'tmall'].include?(kind.to_s)
  end

  def print
    self.printed = true
    save
  end

  def skip_payment
    raise ArgumentError, "Order state must be :generated" if state.to_sym != :generated
    raise ArgumentError, "Total price is greater than 0" if total > 0

    update_attribute(:state, :wait_check)
  end

  def to_coupon_rule_opts
    { total_price: item_total, products: line_items.map(&:product) }
  end

  # Generate an refund
  # Use the payment of the transaction as refund money if amount is not explicitly specified
  #
  # @param transaction [Transaction]
  # @param amount [Decimal] Optional. Refund money
  # @param options [Hash] Other optons
  # @option options [String] :merchant_refund_id Merchant refund id
  # @option options [String] :reason Refund reason
  # @option options [String] :ship_method Ship method, e.g. EMS, Shunfeng
  # @option options [String] :tracking_number Shipment tracking number
  def generate_refund(transaction, amount = nil, options = {})
    raise ArgumentError, "Invalid transaction state: #{transaction.state}" if transaction.state != "completed"
    raise ArgumentError, "Transaction is not belongs to the order" if transaction.order != self

    refunds.create(options.merge(amount: amount || transaction.amount, transaction: transaction))

    cancel if state != 'wait_refund'

    true
  end

  def has_shipped_shipment?
    shipments.where("tracking_num IS NOT NULL AND tracking_num != ''").exists?
  end

  def paid?
    self.state != "generated"
  end

private

  def update_product_stock
    if kind.to_s == 'normal'
      line_items.each do |item|
        item.product.update_stock(item.quantity)
      end
    end
  end

  def print_order
    PrintOrder.from_order(self)
  end

  def process_refund_huali_point
    if self.transaction
      HualiPointService.process_refund(self.user, self.transaction)
    end
  end

  def sync_payment
    update_column(:payment_total,
                     transactions.by_state('completed').map(&:amount).inject(:+))
  end

  def complete_order
    self.completed_at = Time.now
    save
  end

  def update_sold_total
    line_items.each do |item|
      item.product.update_monthly_sold(item.quantity, self.delivery_date)
    end
  end

  def reward_and_rebate_huali_point
    if self.user
      HualiPointService.reward_inviter_point(self.user.inviter, self.user)
      HualiPointService.rebate_point(self.user, self.transaction)
    end
  end
end
