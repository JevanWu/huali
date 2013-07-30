class OrderProductStatisticsQuery
  def initialize(start_date, end_date, relation = Order.unscoped)
    @relation = relation
    @start_date = start_date.to_date
    @end_date = end_date.to_date
  end

  def products_on_date_span
    products.where("orders.delivery_date > ? and orders.delivery_date <= ?", @start_date, @end_date)
  end

  def products_shanghai_on_date_span
    products_shanghai.where("orders.delivery_date > ? and orders.delivery_date <= ?", @start_date, @end_date)
  end

  def watched_products
    date_span.map do |date|
      { date: date, result: products_on_day(date) 
    end
  end

  def watched_products_shanghai
    date_span.map do |date|
      { date: date, result: products_shanghai_on_day(date) }
    end
  end

  private

  def products_on_day(date)
    products.where("orders.delivery_date = ?", date)
  end

  def products_shanghai_on_day(date)
    products_shanghai.where("orders.delivery_date = ?", date)
  end

  def products
    @relation.
      select("products.name_zh, sum(line_items.quantity) as productsCount").
      joins(line_items: :product).
      where("orders.state = 'wait_make' or orders.state = 'wait_ship'").
      group("products.name_zh").
      order("productsCount desc")
  end

  def products_shanghai
    products.joins(address: :province).where("provinces.id = 9")
  end

  def date_span
    @start_date..@end_date
  end
end
