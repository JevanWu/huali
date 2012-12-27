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
#  index_orders_on_identifier  (identifier) UNIQUE
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    number "MyString"
    item_total "9.99"
    total "9.99"
    payment_total "9.99"
    state "MyString"
    payment_state "MyString"
    shipment_state "MyString"
    address nil
    completed_at "2012-11-02 20:46:25"
    user nil
    special_instructions "MyText"
  end
end
