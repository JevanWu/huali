# == Schema Information
#
# Table name: shipments
#
#  address_id           :integer
#  created_at           :datetime         not null
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  kuaidi100_result     :text
#  kuaidi100_status     :integer
#  kuaidi100_updated_at :datetime
#  note                 :text
#  order_id             :integer
#  ship_method_id       :integer
#  state                :string(255)
#  tracking_num         :string(255)
#  updated_at           :datetime         not null
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
    order
    ship_method
    note { Forgery(:lorem_ipsum).paragraph }
    # FIXME use a real mock for tracking_num
    tracking_num { Forgery(:address).zip}

    trait :with_cost do
      cost { Forgery(:monetary).money }
    end
  end
end
