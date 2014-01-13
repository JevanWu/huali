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
#  expected_date        :date             not null
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  kind                 :string(255)      default("normal"), not null
#  merchant_order_no    :string(255)
#  payment_total        :decimal(8, 2)    default(0.0)
#  printed              :boolean          default(FALSE)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  ship_method_id       :integer
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
#  index_orders_on_user_id     (user_id)
#

FactoryGirl.define do
  factory :order do
    user
    address
    expected_date { "2013-01-01".to_date } # Thuesday
    delivery_date { expected_date - 1 }
    gift_card_text { Forgery(:lorem_ipsum).paragraph }
    special_instructions { Forgery(:lorem_ipsum).paragraph }

    source { Forgery(:lorem_ipsum).word }
    sender_name { Forgery(:name).full_name }
    sender_email { Forgery(:internet).email_address }
    sender_phone { "+41 44 668 18 00" }

    after(:build) do |order|
      [1, 2, 3].sample.times do
        order.line_items << build(:line_item)
      end
    end

    trait :wait_check do
      state 'wait_check'
    end

    trait :wait_confirm do
      state 'wait_confirm'
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

    trait :without_line_items do
      after(:create) do |order|
        order.line_items.delete_all
      end
    end

    factory :third_party_order do
      merchant_order_no { '511862112300756' }
      kind { 'taobao' }
    end
  end
end
