# == Schema Information
#
# Table name: orders
#
#  address_id           :integer
#  adjustment           :string(255)
#  completed_at         :datetime
#  coupon_code          :string(255)
#  created_at           :datetime         not null
#  delivery_date        :date
#  expected_date        :date             not null
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  payment_total        :decimal(8, 2)    default(0.0)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  ship_method_id       :string(255)
#  source               :string(255)      default(""), not null
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
    expected_date { Date.current.next_week.next_week.beginning_of_week + 1 } # thuesday
    delivery_date { expected_date - 1 }
    gift_card_text { Forgery(:lorem_ipsum).paragraph }
    special_instructions { Forgery(:lorem_ipsum).paragraph }

    source { Forgery(:lorem_ipsum).word }
    sender_name { Forgery(:name).full_name }
    sender_email { Forgery(:internet).email_address }
    sender_phone { Forgery(:address).phone }

    after(:build) do |order|
      [1, 2, 3].sample.times do
        order.line_items << create(:line_item)
      end
    end

    trait :wait_check do
      state 'wait_check'
    end

    trait :with_one_transaction do
      after(:build) do |order|
        create_list(:transaction, 1, order: order )
      end
    end

    trait :with_multi_transaction do
      after(:build) do |order|
        create_list(:transaction, Forgery(:basic).number, order: order )
      end
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
