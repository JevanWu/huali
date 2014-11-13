# == Schema Information
#
# Table name: discount_events
#
#  created_at     :datetime
#  discount_date  :date
#  id             :integer          not null, primary key
#  original_price :decimal(8, 2)
#  price          :decimal(8, 2)
#  product_id     :integer
#  updated_at     :datetime
#
# Indexes
#
#  index_discount_events_on_discount_date                 (discount_date) UNIQUE
#  index_discount_events_on_product_id                    (product_id)
#  index_discount_events_on_product_id_and_discount_date  (product_id,discount_date)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :discount_event do
    product nil
    discount_date "2014-11-12"
    original_price "9.99"
    price "9.99"
  end
end
