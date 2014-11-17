require 'virtus'

class B2bOrderForm < OrderForm
  attribute :bypass_region_validation, Virtus::Attribute::Boolean, default: false
  attribute :bypass_product_validation, Virtus::Attribute::Boolean, default: false
  attribute :kind, Symbol, default: :normal

  def dispatch_params(order)
    order.except!(:bypass_region_validation,
                  :bypass_product_validation)
    super(order)
  end

  def validate_item?
    super && !bypass_product_validation
  end

  def validate_product_delivery_region?
    super && !bypass_region_validation
  end

  def save
    record = persist!
    bind_record(record)
  end
end
