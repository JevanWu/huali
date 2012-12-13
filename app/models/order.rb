# == Schema Information
#
# Table name: orders
#
#  address_id           :integer
#  completed_at         :datetime
#  created_at           :datetime         not null
#  delivery_date        :date             not null
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  item_total           :decimal(8, 2)    default(0.0), not null
#  number               :string(255)
#  payment_state        :string(255)
#  payment_total        :decimal(8, 2)    default(0.0)
#  shipment_state       :string(255)
#  special_instructions :text
#  state                :string(255)
#  total                :decimal(8, 2)    default(0.0), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_orders_on_number  (number)
#

class Order < ActiveRecord::Base

  attr_accessible :line_items, :address_attributes, :special_instructions,
                  :gift_card_text, :delivery_date

  belongs_to :address
  belongs_to :user

  has_many :line_items, :order => "created_at ASC"
  # has_many :payments, :dependent => :destroy
  # has_many :shipments, :dependent => :destroy

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :address
  # accepts_nested_attributes_for :payments
  # accepts_nested_attributes_for :shipments

  # before_filter :authenticate_user!

  # Queries
  class << self
    def by_number(number)
      where(:number => number)
    end

    def between(start_date, end_date)
      where(:created_at => start_date..end_date)
    end

    def by_customer(customer)
      joins(:user).where("#{Spree.user_class.table_name}.email" => customer)
    end

    def by_state(state)
      where(:state => state)
    end

    def complete
      where('completed_at IS NOT NULL')
    end

    def incomplete
      where(:completed_at => nil)
    end
  end

  def add_line_item(product_id, quantity)
    this_item = LineItem.create(product_id: product_id, quantity: quantity)
    self.line_items << this_item
  end

  def to_param
    number.to_s.to_url.upcase
  end

  def completed?
    !! completed_at
  end

  def checkout_allowed?
    line_items.count > 0
  end
end
