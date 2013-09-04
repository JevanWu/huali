class OrderProductBaseValidator < ActiveModel::Validator
  def validate(order)
    order.line_items.each do |line_item|
      error_attr, error_name = yield line_item, fetch_product(line_item)
      if !error_name.blank?
        order.errors.add(error_attr, error_name)
      end
    end
  end

  private

  def fetch_product(line_item)
    Product.find(line_item.product_id)
  end
end
