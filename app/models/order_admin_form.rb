require 'virtus'

module AdminOnlyInfo
  include Virtus
  attribute :bypass_date_validation, Virtus::Attribute::Boolean, default: false
  attribute :bypass_region_validation, Virtus::Attribute::Boolean, default: false
  attribute :bypass_product_validation, Virtus::Attribute::Boolean, default: false
  attribute :adjustment, String
  attribute :kind, Symbol
  attribute :ship_method_id, Integer
  attribute :delivery_date, Date
end

class OrderAdminForm < OrderForm
  include AdminOnlyInfo

  private 

  def validate_item?
    super && !bypass_product_validation
  end

  def validate_product_delivery_region?
    super && !bypass_region_validation
  end

  def validate_product_delivery_date?
    super && !bypass_date_validation
  end
end