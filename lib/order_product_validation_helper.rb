module OrderProductValidationHelper
  private

  def fetch_product(line_item)
    Product.find(line_item.product_id)
  end

  def sufficient_stock?(line_item)
    product = fetch_product(line_item)
    product.count_on_hand >= line_item.quantity
  end
end

