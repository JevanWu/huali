module OrdersHelper
  def count_total(item)
    number_to_currency (item[:quantity] * item.price), unit: '&yen;'
  end
end
