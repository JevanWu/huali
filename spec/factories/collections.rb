FactoryGirl.define do
  factory :collection do
    name_cn Forgery(:lorem_ipsum).word
    name_en Forgery(:lorem_ipsum).word
    description Forgery(:lorem_ipsum).paragraph

    factory :collection_with_products do
      after(:build) do |collection|
        create_list(:product, Forgery(:basic).number, :with_collection, collection: collection )
      end
    end
  end
end
