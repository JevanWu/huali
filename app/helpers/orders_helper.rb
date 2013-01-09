module OrdersHelper
  def count_total(item)
    number_to_currency (item[:quantity] * item.price), unit: '&yen;'
  end

  def count_cart(items)
    item_total = items.inject(0.0) {|sum, item| sum + item[:quantity] * item.price}
    number_to_currency item_total, unit: '&yen;'
  end
end
