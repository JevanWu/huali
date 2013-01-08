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
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  payment_total        :decimal(8, 2)    default(0.0)
#  special_instructions :text
#  state                :string(255)      default("ready")
#  total                :decimal(8, 2)    default(0.0), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_orders_on_identifier  (identifier) UNIQUE
#

FactoryGirl.define do
  factory :order do
    address
    delivery_date { Date.current.next_week }
    gift_card_text { Forgery(:lorem_ipsum).paragraph }
    special_instructions { Forgery(:lorem_ipsum).paragraph }

    after(:build) do |order|
      create_list(:line_item, Forgery(:basic).number, :with_order, order: order )

      # FIXME the instance needs to be reloaded before access child collections(line_items)
      order.reload
      order.save
    end

    trait :wait_check do
      state 'wait_check'
    end

    trait :with_one_transactions do

    end

    trait :with_multi_transactions do

    end

    trait :with_one_shipment do
      after(:build) do |order|
        create_list(:shipment, 1, order: order )
      end
    end

    trait :with_multi_shipment do
      after(:build) do |order|
        create_list(:shipment, Forgery(:basic).number, order: order )
      end
    end
  end
end
