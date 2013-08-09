class OrderProductsOnDateQuery < ActiveRecord::Base
  self.table_name = "orders"

  belongs_to :address
  has_many :line_items, foreign_key: :order_id
  has_many :products, through: :line_items

  default_scope -> {
      select("products.name_zh, sum(line_items.quantity) as product_count").
      joins(line_items: :product).
      group("products.name_zh").
      order("product_count desc")
  }

  scope :wait_delivery, -> { where("state = 'wait_make' or state = 'wait_ship'") }
  scope :delivered, -> { where("state = 'wait_confirm' or state = 'completed'") }
  scope :in_shanghai, -> { joins(address: :province).where('provinces.id = 9') }
  scope :on_date, ->(date) { where(delivery_date: date) }
  scope :on_date_span, ->(start_date, end_date) { where("orders.delivery_date >= ? and orders.delivery_date <= ?", start_date, end_date) }

  class << self
    def summary_products(start_date, end_date)
      on_date_span(start_date, end_date)
    end

    def summary_products_in_shanghai(start_date, end_date)
      in_shanghai.on_date_span(start_date, end_date)
    end

    def daily_products(start_date, end_date)
      date_span = start_date..end_date
      date_span.map do |date|
        { date: date, result: on_date(date) }
      end
    end

    def daily_products_in_shanghai(start_date, end_date)
      date_span = start_date..end_date
      date_span.map do |date|
        { date: date, result: on_date(date).in_shanghai }
      end
    end
  end
end
