require 'virtus'
require 'active_model'
require 'phonelib_extension'
require 'validators/all'

class ReceiverInfo
  include Virtus
  include Virtus::ValueObject
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include Phonelib::Extension

  attr_reader :errors

  attribute :fullname, String
  attribute :phone, String
  attribute :province_id, Integer
  attribute :city_id, Integer
  attribute :area_id, Integer
  attribute :address, String
  attribute :post_code, Integer

  validates_presence_of :fullname, :address, :phone, :province_id, :city_id, :post_code

  phoneize :phone
  validates :phone, phone: { allow_blank: true }

  def initialize(*)
    super
    @errors = ActiveModel::Errors.new(self)
  end
  alias :read_attribute_for_validation :send
end

class ItemInfo
  include Virtus
  include Virtus::ValueObject
  extend ActiveModel::Translation
  extend ActiveModel::Naming

  attr_reader :errors

  def initialize(*)
    super
    self.price = product.price if product_id

    @errors = ActiveModel::Errors.new(self)
  end
  alias :read_attribute_for_validation :send

  attribute :product_id, Integer
  attribute :quantity, Integer, default: 0
  attribute :price, Float

  def product
    Product.find(product_id)
  end

  def total
    price * quantity
  end
end

class SenderInfo
  include Virtus::ValueObject
  include Virtus
  include ActiveModel::Validations
  include Phonelib::Extension

  def initialize(*)
    super
    @errors = ActiveModel::Errors.new(self)
  end

  attribute :name, String
  attribute :email, String
  attribute :phone, String

  phoneize :phone
  validates :phone, phone: { allow_blank: true }

  validates_presence_of :email, :phone, :name
end

module OrderInfo
  include Virtus

  attribute :coupon_code, String
  attribute :gift_card_text, String
  attribute :special_instructions, String
  attribute :source, String, default: ''
  attribute :expected_date, Date
end

# The Role of OrderForm
# - validation and render error information in the frontend form
# - attributes naming and type restrictions (replace strong parameters)
# - build related records
# - Inherited Behavior for specialized builds

class OrderForm
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :user
  include OrderInfo
  attribute :sender, SenderInfo
  attribute :address, ReceiverInfo
  attribute :line_items, Array[ItemInfo]

  validates_with OrderProductRegionValidator, if: :validate_product_delivery_region?
  validates_with OrderProductDateValidator, if: :validate_product_delivery_date?
  validates_with OrderCustomizedRegionValidator, if: :validate_product_delivery_date?
  validates_with OrderItemValidator, if: :validate_item?
  validates_with OrderProductAvailabilityValidator, if: :validate_item?
  validates_with OrderCouponValidator, if: :validate_coupon?

  validates :expected_date, presence: true

  def save
    return false unless valid?
    begin
      record = persist!
      yield(record) and record.save! if block_given?
      bind_record(record)
      true
    rescue ActiveRecord::ActiveRecordError
      false
    end
  end

  # FIXME, add the price info into cookie and remove this query
  def item_total
    line_items.map(&:total).reduce(:+)
  end

  def add_line_item(product_id, quantity)
    # use << won't coerce the Item object
    self.line_items += [ {product_id: product_id, quantity: quantity} ]
  end

  def valid?
    # trigger valid? to populate errors
    [sender.valid?, address.valid?, super].inject(:&)
  end

  attr_reader :record
  def bind_record(record)
    @record = record
  end

  def persisted?
    !!@record
  end

  def to_key
    @record && [@record.id]
  end

  def to_coupon_rule_opts
    { total_price: item_total, products: line_items.map(&:product) }
  end

  private

  def validate_coupon?
    not_yet_shipped?
  end

  def validate_item?
    not_yet_shipped?
  end

  def validate_product_delivery_region?
    not_yet_shipped?
  end

  def validate_product_delivery_date?
    expected_date.present? && not_yet_shipped?
  end

  def not_yet_shipped?
    true
  end

  def persist!
    order, address, line_items = dispatch_params(to_hash)

    # build address
    address = Address.new(address)
    address.user = user

    # build line_items
    line_items.map! { |params| LineItem.new(params) }

    # build order
    order = Order.new(order)
    order.address = address
    order.user = user
    order.line_items = line_items
    order.save!
    return order
  end

  def dispatch_params(order)
    sender = order.delete(:sender)
    order.merge!({ sender_name: sender.name,
                   sender_email: sender.email,
                   sender_phone: sender.phone })

    address = order.delete(:address).to_hash
    line_items = order.delete(:line_items).map(&:to_hash)

    return order, address, line_items
  end
end
