# encoding: utf-8
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
#  printed              :boolean          default(FALSE)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  ship_method_id       :string(255)
#  source               :string(255)      default(""), not null
#  special_instructions :text
#  state                :string(255)      default("ready")
#  total                :decimal(8, 2)    default(0.0), not null
#  type                 :string(255)      default("normal"), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_orders_on_identifier  (identifier) UNIQUE
#  index_orders_on_user_id     (user_id)
#

class Order < ActiveRecord::Base
  self.inheritance_column = 'sti_type'

  attr_accessor :bypass_region_validation, :bypass_date_validation, :bypass_product_validation

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

  extend Enumerize
  enumerize :type, in: [:normal, :marketing, :customer, :taobao], default: :normal

  delegate :province_name, :city_name, to: :address, allow_nil: true
  delegate :paymethod, to: :transaction, allow_nil: true
  delegate :province_id, :city_id, :area_id, to: :address, prefix: 'address', allow_nil: true

  before_validation :generate_identifier, on: :create

  validates_format_of :adjustment,
                      with: %r{\A[+-x*%/][\s\d.]+\z}, # +/-/*/%1234.0
                      unless: lambda { |order| order.adjustment.blank? }

  validates_presence_of :identifier, :line_items, :expected_date, :state, :total, :item_total, :sender_email, :sender_phone, :sender_name

  validates_with OrderProductRegionValidator, if: :validate_product_delivery_region?
  validates_with OrderProductDateValidator, if: :validate_product_delivery_date?
  validates_with OrderProductValidator, if: lambda { |order| !order.bypass_product_validation }

  # only validate once on Date.today, because in future Date.today will change
  validate :phone_validate, unless: lambda { |order| order.sender_phone.blank? }
  # skip coupon code validation for empty coupon and already used coupon
  validate :coupon_code_validate, unless: lambda { |order| order.coupon_code.blank? || order.already_use_the_coupon? }

  validate :delivery_date_must_be_less_than_expected_date

  after_validation :cal_item_total, :cal_total
  after_validation :adjust_total, if: :adjust_allowed?
  after_validation :use_coupon, unless: lambda { |order| order.coupon_code.blank? }

  state_machine :state, initial: :generated do
    # TODO implement an auth_state dynamically for each state
    before_transition to: :wait_refund, do: :auth_refund
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

  # Skip date and region validation in statemachine
  [:pay, :check, :make].each do |m|
    define_method(m) do |*args|
      self.bypass_date_validation = true
      self.bypass_region_validation = true

      super(*args)
    end
  end

  scope :yesterday, -> { where 'delivery_date = ?', Date.yesterday }
  scope :current, -> { where 'delivery_date = ?', Date.current }
  scope :tomorrow, -> { where 'delivery_date = ?', Date.tomorrow }
  scope :next_two_day, -> { where 'delivery_date = ?', Date.current.next_day(2) }
  scope :within_this_week, -> { where('delivery_date >= ? AND delivery_date <= ? ', Date.current.beginning_of_week, Date.current.end_of_week) }
  scope :within_this_month, -> { where('delivery_date >= ? AND delivery_date <= ? ', Date.current.beginning_of_month, Date.current.end_of_month) }
  scope :accountable, -> { where("type = 'normal'").where("state != 'void' and state != 'generated'") }
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

  [:bypass_region_validation, :bypass_date_validation, :bypass_product_validation].each do |m|
    define_method(:"#{m}=") do |value|
      instance_variable_set(:"@#{m}", ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value))
    end
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

  def add_line_item(product_id, quantity)
    self.line_items.build(product_id: product_id, quantity: quantity)
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
    # cannot use double discount
    # return if item_discount?

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

  def fetch_products
    @fetched_products ||= if self.persisted?
                            products
                          else
                            line_items.map { |l| Product.find(l.product_id) }
                          end
  end

  private

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

  def update_sold_total
    line_items.each do |item|
      product = item.product
      product.sold_total += item.quantity
      product.save
    end
  end

  def pay_order
    self.payment_total += self.transactions.by_state('completed').map(&:amount).inject(:+)
    save
  end

  def validate_product_delivery_region?
    address_province_id && address_city_id && not_yet_shipped? && !bypass_region_validation
  end

  def validate_product_delivery_date?
    expected_date.present? && not_yet_shipped? && !bypass_date_validation
  end

  def delivery_date_must_be_less_than_expected_date
    if delivery_date && !(delivery_date < expected_date)
      errors.add(:delivery_date, :must_be_less_than_expected_date)
    end
  end
end
