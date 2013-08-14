require 'virtus'
require 'active_model'
require 'order_product_region_validator'
require 'order_product_date_validator'
require 'order_coupon_validator'
require 'order_item_validator'

class ReceiverInfo
  include Virtus
  include Virtus::ValueObject
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_reader :errors

  attribute :fullname, String
  attribute :phone, String
  attribute :province_id, Integer
  attribute :city_id, Integer
  attribute :area_id, Integer
  attribute :address, String
  attribute :post_code, String

  validates_presence_of :fullname, :address, :phone, :province_id, :city_id, :post_code

  def initialize(*)
    super
    @errors = ActiveModel::Errors.new(self)
  end
  alias :read_attribute_for_validation :send
end

class ItemInfo
  include Virtus
  include Virtus::ValueObject

  attribute :product_id, Integer
  attribute :quantity, Integer
end

class SenderInfo
  include Virtus::ValueObject
  include Virtus
  include ActiveModel::Validations

  def initialize(*)
    super
    @errors = ActiveModel::Errors.new(self)
  end

  attribute :name, String
  attribute :email, String
  attribute :phone, String

  validates_presence_of :email, :phone, :name
end

module OrderInfo
  include Virtus

  attribute :bypass_date_validation, Virtus::Attribute::Boolean, default: false
  attribute :bypass_region_validation, Virtus::Attribute::Boolean, default: false
  attribute :bypass_product_validation, Virtus::Attribute::Boolean, default: false
  attribute :coupon_code, String
  attribute :gift_card_text, String
  attribute :special_instructions, String
  attribute :source, String
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
  # validates_with OrderItemValidator, if: :validate_item?
  validates_with OrderCouponValidator, unless: lambda { |order| order.coupon_code.blank? }

  def fetch_products
    line_items.map { |l| Product.find(l.product_id) }
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def add_line_item(product_id, quantity)
    # use << won't coerce the Item object
    self.line_items += [ {product_id: product_id, quantity: quantity} ]
  end

  def valid?
    # trigger valid? to populate errors
    [sender.valid?, address.valid?, super].inject(:&)
  end

  def persisted?
    false
  end
  
  private

  def validate_item?
    not_yet_shipped? && !bypass_product_validation
  end

  def validate_product_delivery_region?
    not_yet_shipped? && !bypass_region_validation
  end

  def validate_product_delivery_date?
    not_yet_shipped? && !bypass_date_validation
  end

  def not_yet_shipped?
    true
  end

  def persist!
    # build user
    # build address
    # build line_items
    # build order
  end
end
