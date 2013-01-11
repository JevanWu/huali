# == Schema Information
#
# Table name: collections
#
#  created_at  :datetime         not null
#  description :string(255)
#  id          :integer          not null, primary key
#  name_en     :string(255)      not null
#  name_zh     :string(255)      not null
#  updated_at  :datetime         not null
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
