class ReceiverInfo
  include Virtus
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  attr_reader :errors

  attribute :fullname, String
  attribute :phone, String
  attribute :province_id, String
  attribute :city_id, String
  attribute :area_id, String
  attribute :address, String
  attribute :post_code, String

  def initialize(*)
    super
    @errors = ActiveModel::Errors.new(self)
  end
  alias :read_attribute_for_validation :send
end

class ItemInfo
  include Virtus
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  attr_reader :errors

  attribute :id, String
  attribute :quantity, Integer

  def initialize(*)
    super
    @errors = ActiveModel::Errors.new(self)
  end
  alias :read_attribute_for_validation :send
end

class UserInfo
  include Virtus

  attribute :name, String
  attribute :email, String
  attribute :phone, String
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
  attribute :sender, UserInfo
  attribute :address, ReceiverInfo
  attribute :line_items, Array[ItemInfo]

  validates_with OrderProductRegionValidator, if: :validate_product_delivery_region?
  validates_with OrderProductDateValidator, if: :validate_product_delivery_date?
  # validates_with OrderProductValidator, unless: lambda { |order| order.bypass_product_validation }
  validates_with OrderCouponValidator, unless: lambda { |order| order.coupon_code.blank? }

  def validate_product_delivery_region?
    not_yet_shipped? && !bypass_region_validation
  end

  def validate_product_delivery_date?
    not_yet_shipped? && !bypass_date_validation
  end

  def fetch_products
    line_items.map { |l| Product.find(l.id) }
  end

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def add_line_item(id, quantity)
    # use << won't coerce the Item object
    self.line_items += [ {id: id, quantity: quantity} ]
  end

  private

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
