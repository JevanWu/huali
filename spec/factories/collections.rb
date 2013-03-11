# == Schema Information
#
# Table name: collections
#
#  available        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  description      :string(255)
#  display_name     :string(255)
#  id               :integer          not null, primary key
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  name_en          :string(255)      not null
#  name_zh          :string(255)      not null
#  primary_category :boolean          default(FALSE), not null
#  slug             :string(255)
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_collections_on_slug  (slug) UNIQUE
#

FactoryGirl.define do
  factory :collection do
    name_cn { Forgery(:lorem_ipsum).word }
    name_en { Forgery(:lorem_ipsum).word }
    description { Forgery(:lorem_ipsum).sentence }

    factory :collection_with_products do
      after(:build) do |collection|
        create_list(:product, Forgery(:basic).number, :with_collection, collection: collection )
      end
    end
  end
end
