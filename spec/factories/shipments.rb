# == Schema Information
#
# Table name: shipments
#
#  address_id     :integer
#  cost           :integer
#  created_at     :datetime         not null
#  id             :integer          not null, primary key
#  identifier     :string(255)
#  note           :text
#  order_id       :integer
#  ship_method_id :integer
#  state          :string(255)
#  tracking_num   :string(255)
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_shipments_on_identifier      (identifier)
#  index_shipments_on_order_id        (order_id)
#  index_shipments_on_ship_method_id  (ship_method_id)
#  index_shipments_on_tracking_num    (tracking_num)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipment do
    identifier "MyString"
    state "MyString"
    note "MyText"
    cost 1
    address nil
    ship_method nil
    order nil
  end
end
