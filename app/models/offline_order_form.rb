require 'virtus'

class OfflineOrderForm < OrderForm
  attribute :bypass_date_validation, Virtus::Attribute::Boolean, default: false
  attribute :bypass_region_validation, Virtus::Attribute::Boolean, default: false
  attribute :bypass_product_validation, Virtus::Attribute::Boolean, default: false
  attribute :adjustment, String
  attribute :kind, Symbol, default: :normal
  attribute :ship_method_id, Integer
  attribute :delivery_date, Date
  attribute :paymethod, String
  attribute :created_at, Date

  # +/-/*/%1234.0
  validates_format_of :adjustment, with: %r{\A[+-x*%/][\s\d.]+\z}, allow_blank: true
  validates_with OrderDeliveryDateValidator

  validates :paymethod, presence: true

  private

  def dispatch_params(order)
    order.except!(:bypass_date_validation,
                  :bypass_region_validation,
                  :bypass_product_validation)
    super(order)
  end

  def validate_item?
    super && !bypass_product_validation
  end

  def validate_product_delivery_region?
    super && !bypass_region_validation
  end

  def validate_product_delivery_date?
    super && !bypass_date_validation
  end

  def to_hash
    super.except(:paymethod)
  end
end

