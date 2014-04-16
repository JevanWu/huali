# == Schema Information
#
# Table name: orders
#
#  address_id           :integer
#  adjustment           :string(255)
#  completed_at         :datetime
#  coupon_code_id       :integer
#  created_at           :datetime         not null
#  delivery_date        :date
#  expected_date        :date
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  kind                 :string(255)      default("normal"), not null
#  last_order           :string(255)
#  memo                 :text
#  merchant_order_no    :string(255)
#  payment_total        :decimal(8, 2)    default(0.0)
#  prechecked           :boolean
#  printed              :boolean          default(FALSE)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  ship_method_id       :integer
#  source               :string(255)      default(""), not null
#  special_instructions :text
#  state                :string(255)      default("ready")
#  subject_text         :text             default("")
#  total                :decimal(8, 2)    default(0.0), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#  validation_code      :string(255)
#
# Indexes
#
#  index_orders_on_identifier                  (identifier) UNIQUE
#  index_orders_on_merchant_order_no_and_kind  (merchant_order_no,kind)
#  index_orders_on_user_id                     (user_id)
#

class OrderProductsOnDateQuery < ActiveRecord::Base
  self.table_name = "orders"

  belongs_to :address
  has_many :line_items, foreign_key: :order_id
  has_many :products, through: :line_items
  belongs_to :ship_method

  default_scope -> {
      select("products.name_zh, sum(line_items.quantity) as product_count").
      joins(line_items: :product).
      group("products.name_zh").
      order("product_count desc")
  }

  scope :wait_delivery, -> { where("state = 'wait_make' or state = 'wait_ship'") }
  scope :delivered, -> { where("state = 'wait_confirm' or state = 'completed'") }
  scope :manual, -> { joins(:ship_method).where('ship_methods.id = 3') }
  scope :on_date, ->(date) { where(delivery_date: date) }
  scope :on_date_span, ->(start_date, end_date) { where("orders.delivery_date >= ? and orders.delivery_date <= ?", start_date, end_date) }

  class << self
    def summary_products(start_date, end_date)
      on_date_span(start_date, end_date)
    end

    def summary_products_manual(start_date, end_date)
      manual.on_date_span(start_date, end_date)
    end

    def daily_products(start_date, end_date)
      date_span = start_date..end_date
      date_span.map do |date|
        { date: date, result: on_date(date) }
      end
    end

    def daily_products_manual(start_date, end_date)
      date_span = start_date..end_date
      date_span.map do |date|
        { date: date, result: on_date(date).manual }
      end
    end
  end
end
