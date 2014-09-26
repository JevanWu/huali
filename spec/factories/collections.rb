# == Schema Information
#
# Table name: collections
#
#  available             :boolean          default(FALSE)
#  created_at            :datetime         not null
#  description           :string(255)
#  display_name          :string(255)
#  display_on_breadcrumb :boolean          default(FALSE)
#  id                    :integer          not null, primary key
#  meta_description      :string(255)
#  meta_keywords         :string(255)
#  meta_title            :string(255)
#  name_en               :string(255)      not null
#  name_zh               :string(255)      not null
#  parent_id             :integer
#  primary_category      :boolean          default(FALSE), not null
#  priority              :integer          default(5)
#  slug                  :string(255)
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_collections_on_slug  (slug) UNIQUE
#

FactoryGirl.define do
  factory :collection do
    name_zh { Forgery(:lorem_ipsum).word }
    name_en { Forgery(:lorem_ipsum).word }
    display_name { Forgery(:lorem_ipsum).word }
    description { Forgery(:lorem_ipsum).sentence }
    available true
    primary_category true

    factory :collection_with_products do
      after(:build) do |collection|
        create_list(:product, rand(2..5))
      end
    end

    trait :with_parent do
      after(:build) do |collection|
        collection.parent = create(:collection)
      end
    end
  end
end
