# == Schema Information
#
# Table name: shipments
#
#  address_id     :integer
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
    state :ready
    association :order, state: 'wait_ship'
    ship_method
    note { Forgery(:lorem_ipsum).paragraph }
    # FIXME use a real mock for tracking_num
    tracking_num { Forgery(:address).zip }

    trait :is_manual do
      association :ship_method, :manual
    end
  end
end
