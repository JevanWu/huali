# == Schema Information
#
# Table name: print_orders
#
#  card_printed     :boolean          default(FALSE)
#  created_at       :datetime
#  id               :integer          not null, primary key
#  order_id         :integer
#  order_printed    :boolean          default(FALSE)
#  print_group_id   :integer
#  shipment_printed :boolean          default(FALSE)
#  updated_at       :datetime
#
# Indexes
#
#  index_print_orders_on_order_id        (order_id) UNIQUE
#  index_print_orders_on_print_group_id  (print_group_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :print_order do
    order nil
    print_group nil
    order_printed false
    card_printed false
    shipment_printed false
  end
end
