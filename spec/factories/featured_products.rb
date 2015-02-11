# == Schema Information
#
# Table name: featured_products
#
#  available          :boolean          default(TRUE)
#  cover_content_type :string(255)
#  cover_file_name    :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  created_at         :datetime
#  description        :text
#  id                 :integer          not null, primary key
#  priority           :integer
#  product_id         :integer
#  updated_at         :datetime
#
# Indexes
#
#  index_featured_products_on_product_id  (product_id)
#



# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :featured_product do
    description "MyText"
    available false
    priority 1
    product nil
  end
end
