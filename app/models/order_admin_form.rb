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

  class << self
    def build_from_record(record)
      order_admin_form = new(record.as_json)
      order_admin_form.sender = extract_sender(record)
      order_admin_form.address = extract_address(record)
      order_admin_form.line_items = extract_line_items(record)
      order_admin_form.coupon_code = extract_coupon_code(record)
      order_admin_form.bind_record(record)

      return order_admin_form
    end

    private

    def extract_sender(record)
      SenderInfo.new({
        email: record.sender_email,
        phone: record.sender_phone,
        name: record.sender_name
      })
    end

    def extract_address(record)
      ReceiverInfo.new(record.address.as_json)
    end

    def extract_line_items(record)
      record.line_items.map do |item|
        ItemInfo.new(item.as_json)
      end
    end

    def extract_coupon_code(record)
      record.coupon.try(:code)
    end
  end

  def bind_record(record)
    @record = record
  end

  def persisted?
    !!@record
  end

  private 

  def persist!
    if persisted?
      update!
    else
      super
    end
  end

  def update!
    order, address, line_items = dispatch_params(to_hash)

    @record.update_attributes(order)
    @record.address.update_attributes(address)

    # rebuild line_items
    @record.line_items.destroy_all
    @record.line_items = line_items.map { |params| LineItem.new(params) }
    @record.save!
  end

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
end
