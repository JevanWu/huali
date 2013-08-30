class OrderProductBaseValidator < ActiveModel::Validator
  def validate(order)
    order.line_items.each do |line_item|
      yield line_item, fetch_product(line_item)
    end
  end

  private

  def fetch_product(line_item)
    Product.find(line_item.product_id)
  end
end