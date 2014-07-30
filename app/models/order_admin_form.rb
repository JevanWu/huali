require 'virtus'

class OrderAdminForm < OrderForm
  attribute :bypass_date_validation, Virtus::Attribute::Boolean, default: false
  attribute :bypass_region_validation, Virtus::Attribute::Boolean, default: false
  attribute :bypass_product_validation, Virtus::Attribute::Boolean, default: false
  attribute :merchant_order_no, String
  attribute :adjustment, String
  attribute :kind, Symbol, default: :normal
  attribute :ship_method_id, Integer
  attribute :delivery_date, Date
  attribute :last_order, String
  attribute :prechecked, Virtus::Attribute::Boolean
  attribute :memo, String

  # +/-/*/%1234.0
  validates_format_of :adjustment, with: %r{\A[+-x*%/][\s\d.]+\z}, allow_blank: true
  validates_with OrderDeliveryDateValidator

  validate do |order|
    if order.merchant_order_no.present?
      duplicate_orders = Order.where(merchant_order_no: order.merchant_order_no, kind: order.kind)
      duplicate_orders = duplicate_orders.where("id != ?", to_key) unless to_key.nil?

      if duplicate_orders.exists?
        errors.add :merchant_order_no, :taken
      end
    end
  end

  validates :last_order, presence: true, if: Proc.new { |order| order.kind.to_s == "customer" }
  validate :able_to_edit_adjustment

  class << self
    def build_from_record(record)
      order_admin_form = new(record.as_json)
      order_admin_form.sender = extract_sender(record)
      order_admin_form.address = extract_address(record)
      order_admin_form.line_items = extract_line_items(record)
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
  end

  private

  def validate_coupon?
    persisted? ? false : true
  end

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

    # rebuild line_items if item could changes
    if validate_item?
      @record.line_items.destroy_all
      @record.update_columns(subject_text: "")
      @record.line_items = line_items.map { |params| LineItem.new(params) }
    end

    @record.save!
    @record
  end

  def dispatch_params(order)
    order.except!(:bypass_date_validation,
                  :bypass_region_validation,
                  :bypass_product_validation)
    super(order)
  end

  def validate_item?
    return false unless not_yet_shipped?

    super && !bypass_product_validation
  end

  def validate_product_delivery_region?
    super && !bypass_region_validation
  end

  def validate_product_delivery_date?
    super && !bypass_date_validation
  end

  def able_to_edit_adjustment
    errors.add(:adjustment, :not_able_to_edit_adjustment) if !not_yet_shipped? && adjustment != @record.adjustment
  end

  def not_yet_shipped?
    ['generated', 'wait_check', 'wait_make'].include?(@record.state)
  end
end
