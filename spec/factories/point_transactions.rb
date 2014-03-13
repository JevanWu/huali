# == Schema Information
#
# Table name: point_transactions
#
#  created_at       :datetime
#  description      :string(255)
#  expires_on       :date
#  id               :integer          not null, primary key
#  point            :integer          default(0)
#  transaction_id   :integer
#  transaction_type :string(255)
#  updated_at       :datetime
#  user_id          :integer
#
# Indexes
#
#  index_point_transactions_on_transaction_id  (transaction_id)
#  index_point_transactions_on_user_id         (user_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :point_transaction do
    point 1
    transaction_type "MyString"
    description "MyString"
    expires_on "2014-02-26"
    user nil
    transaction nil
  end
end
