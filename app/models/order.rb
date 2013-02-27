# == Schema Information
#
# Table name: orders
#
#  address_id           :integer
#  adjustment           :string(255)
#  completed_at         :datetime
#  coupon_code          :string(255)
#  created_at           :datetime         not null
#  delivery_date        :date
#  expected_date        :date             not null
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  payment_total        :decimal(8, 2)    default(0.0)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
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
#

class Order < ActiveRecord::Base

  attr_accessible :line_items, :special_instructions, :address_attributes,
                  :gift_card_text, :delivery_date, :expected_date, :identifier, :state,
                  :sender_name, :sender_phone, :sender_email, :source, :adjustment, :coupon_code,
                  :ship_method_id

  belongs_to :address
  belongs_to :user
  # just for convenient meta-methods
  belongs_to :ship_method

  has_many :line_items, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :shipments, dependent: :destroy
  has_many :products, through: :line_items
  has_one :order_coupon
  has_one :coupon, through: :order_coupon

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :address

  before_validation :generate_identifier, on: :create

  validates_format_of :adjustment,
                      with: %r{\A[+-x*%/][\s\d.]+}, # +/-/*/%1234.0
                      unless: lambda { |order| order.adjustment.blank? }

  validates_presence_of :identifier, :line_items, :expected_date, :state, :total, :item_total, :sender_email, :sender_phone, :sender_name, :source

  # only validate once on Date.today, because in future Date.today will change
  validate :expected_date_in_range, on: :create
  validate :phone_validate, unless: lambda { |order| order.sender_phone.blank? }
  # skip coupon code validation for empty coupon and already used coupon
  validate :coupon_code_validate, unless: lambda { |order| order.coupon_code.blank? || order.already_use_the_coupon? }

  after_validation :cal_item_total, :cal_total
  after_validation :adjust_total, if: :adjust_allowed?
  after_validation :use_coupon, unless: lambda { |order| order.coupon_code.blank? }

  state_machine :state, initial: :generated do
    # TODO implement an auth_state dynamically for each state
    before_transition to: :wait_refund, do: :auth_refund
    before_transition to: :completed, do: :complete_order
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
    end

    state :wait_refund do
      transition to: :void, on: :refund
    end
  end

  scope :all, -> { reorder }
  scope :current, -> { where 'delivery_date = ?', Date.current }
  scope :tomorrow, -> { where 'delivery_date = ?', Date.tomorrow }
  scope :next_two_day, -> { where 'delivery_date = ?', Date.current.next_day(2) }
  scope :within_this_week, -> { where('delivery_date >= ? AND delivery_date <= ? ', Date.current.beginning_of_week, Date.current.end_of_week) }
  scope :within_this_month, -> { where('delivery_date >= ? AND delivery_date <= ? ', Date.current.beginning_of_month, Date.current.end_of_month) }

  default_scope -> { order("created_at DESC") }

  # Queries
  class << self

    def by_number(number)
      where(number: number)
    end

    def between(start_date, end_date)
      where(created_at: start_date..end_date)
    end

    def by_customer(customer)
      joins(:user).where("#{Spree.user_class.table_name}.email" => customer)
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

  def generate_identifier
    self.identifier = uid_prefixed_by('OR')
  end

  def generate_transaction(pay_info, options = {})
    default = {
      amount: self.total,
      subject: subject_text,
      body: body_text
    }
    self.transactions.create default.merge(options), pay_info
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

  def add_line_item(product_id, quantity)
    this_item = LineItem.create(product_id: product_id, quantity: quantity)
    self.line_items << this_item
  end

  def cal_item_total
    self.item_total = line_items.map(&:total).inject(:+)
  end

  def cal_total
    self.total = self.item_total
  end

  def adjust_total(adjust_string = adjustment)
    # convert symbol to valid arithmetic operator
    adjust = adjust_string.squeeze(' ').sub('x', '*').sub('%', '/')
    operator, number = [adjust.first.to_sym, adjust[1..-1].to_f]
    self.total = self.item_total.send(operator, number)
  end

  def use_coupon
    # respect the manual adjustment
    return unless adjustment.blank?

    # if the coupon is already used by this order
    if already_use_the_coupon?
      adjust_total(coupon.adjustment)
    else
      # bind the coupon
      self.coupon = Coupon.find_by_code(self.coupon_code)

      # adjust the total with exist coupon's adjustment
      adjust_string = self.coupon && self.coupon.use!
      if adjust_string
        adjust_total(adjust_string)
      end
    end
  end

  def already_use_the_coupon?
    coupon.try(:code) == coupon_code
  end

  def completed?
    !! completed_at
  end

  def adjust_allowed?
    state == 'generated' && !adjustment.blank?
  end

  def checkout_allowed?
    line_items.count > 0
  end

  def cancel_allowed?
    state.in? ['generated', 'wait_check']
  end

  def transaction_state
    transaction.state
  end

  def shipment_state
    shipment.state
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

  private

  def expected_date_in_range
    unless expected_date.in? Date.today.tomorrow..Date.today.next_month
      errors.add :expected_date, :unavailable_date
    end

    if expected_date.monday? or expected_date.sunday?
      errors.add :expected_date, :unavailable_date
    end
  end

  def phone_validate
    n_digits = sender_phone.scan(/[0-9]/).size
    valid_chars = (sender_phone =~ /^[-+()\/\s\d]+$/)
    errors.add :sender_phone, :invalid unless (n_digits >= 8 && valid_chars)
  end

  def coupon_code_validate
    co = Coupon.find_by_code(coupon_code)
    if co
      errors.add :coupon_code, :expired_coupon unless co.usable?
    else
      errors.add :coupon_code, :non_exist_coupon
    end
  end

  def auth_refund
    # TODO auth the admin for the refund actions
    true
  end

  def complete_order
    self.completed_at = Time.now
    save
  end

  def pay_order
    self.payment_total += self.transactions.by_state('completed').map(&:amount).inject(:+)
    save
  end
end
