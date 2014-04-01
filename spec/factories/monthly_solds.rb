# == Schema Information
#
# Table name: monthly_solds
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  product_id :integer
#  sold_month :integer
#  sold_total :integer          default(0)
#  sold_year  :integer
#  updated_at :datetime
#
# Indexes
#
#  index_monthly_solds_on_product_id                               (product_id)
#  index_monthly_solds_on_product_id_and_sold_year_and_sold_month  (product_id,sold_year,sold_month) UNIQUE
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :monthly_sold do
    sold_year { Date.current.year }
    sold_month { Date.current.month }
    sold_total 100
    product
  end
end
