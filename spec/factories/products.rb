FactoryGirl.define do
  factory :product do
    name_cn Forgery(:lorem_ipsum).word
    name_en Forgery(:lorem_ipsum).word
    name_char Forgery(:lorem_ipsum).character
    description Forgery(:lorem_ipsum).paragraph
    inspiration Forgery(:lorem_ipsum).sentence
    related_text Forgery(:lorem_ipsum).paragraph
    info_source Forgery(:lorem_ipsum).paragraph

    count_on_hand Forgery(:basic).number

    cost_price Forgery(:monetary).money
    price Forgery(:monetary).money
    original_price Forgery(:monetary).money

    height Forgery(:basic).number({at_least: 10, at_most: 1000})
    width Forgery(:basic).number({at_least: 10, at_most: 1000})
    depth Forgery(:basic).number({at_least: 10, at_most: 1000})

    meta_description Forgery(:lorem_ipsum).paragraph
    meta_keywords Forgery(:lorem_ipsum).words(20)


    trait :available do
      available true
    end

    trait :unavailable do
      available false
    end

    trait :with_collection do
      collection
    end

    # collection_id
    # slug
  end
end
