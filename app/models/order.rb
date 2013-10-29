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
#  expected_date        :date             not null
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  kind                 :string(255)      default("normal"), not null
#  merchant_order_no    :string(255)
#  payment_total        :decimal(8, 2)    default(0.0)
#  printed              :boolean          default(FALSE)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  ship_method_id       :integer
#  source               :string(255)      default(""), not null
#  special_instructions :text
#  state                :string(255)      default("ready")
#  total                :decimal(8, 2)    default(0.0), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_orders_on_identifier  (identifier) UNIQUE
#  index_orders_on_user_id     (user_id)
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
  has_many :products, through: :line_items
  belongs_to :coupon_code_record, foreign_key: :coupon_code_id, class_name: 'CouponCode'

  extend Enumerize
  enumerize :kind, in: [:normal, :jd, :tencent, :xigua, :marketing, :customer, :taobao, :b2b], default: :normal

  delegate :province_name, :city_name, to: :address, allow_nil: true
  delegate :paymethod, to: :transaction, allow_nil: true
  delegate :province_id, :city_id, :area_id, to: :address, prefix: 'address', allow_nil: true

  before_validation :generate_identifier, on: :create

  validates_presence_of :identifier, :line_items, :state, :total, :item_total

  after_validation :cal_item_total, :cal_total

  state_machine :state, initial: :generated do
    # TODO implement an auth_state dynamically for each state
    before_transition to: :completed, do: :complete_order
    after_transition to: :completed, do: :update_sold_total
    before_transition to: :wait_check, do: :pay_order
    after_transition to: :wait_ship, do: :generate_shipment

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
  scope :in_day, lambda { |date| where("DATE(created_at AT TIME ZONE 'utc') = DATE(?)", date) }
  scope :unpaid_today, lambda { |hours_ago| in_day(Date.current).where(state: 'generated').where("created_at <= ?", hours_ago.hours.ago) }

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

  def finished?
    ["completed", "refunded", "void"].include?(state)
  end

  def not_yet_shipped?
    state.in?(['generated', 'wait_check', 'wait_make'])
  end

  def generate_identifier
    self.identifier = uid_prefixed_by('OR')
  end

  def generate_transaction(opts)
    default = {
      amount: self.total,
      subject: subject_text,
      body: body_text
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
    self.item_total = line_items.map(&:total).inject(:+)
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
    transactions.last
  end

  def shipment
    shipments.last
  end

  def subject_text
    line_items.inject('') { |sum, item| sum + "#{item.name} x #{item.quantity}, "}
  end

  def body_text
    # prepare body text for transaction
  end

  def from_taobao?
    source == '淘宝' or special_instructions.index('淘宝')
  end

  def print
    self.printed = true
    save
  end

  private

  def complete_order
    self.completed_at = Time.now
    save
  end

  def update_sold_total
    line_items.each do |item|
      product = item.product
      product.sold_total += item.quantity
      product.save
    end
  end

  def pay_order
    self.payment_total = self.transactions.by_state('completed').map(&:amount).inject(:+)
    save
  end
end
