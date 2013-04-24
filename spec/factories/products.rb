# == Schema Information
#
# Table name: products
#
#  available            :boolean          default(TRUE)
#  cost_price           :decimal(8, 2)
#  count_on_hand        :integer          default(0), not null
#  created_at           :datetime         not null
#  depth                :decimal(8, 2)
#  description_en       :text
#  description_zh       :text
#  height               :decimal(8, 2)
#  id                   :integer          not null, primary key
#  inspiration_en       :text
#  inspiration_zh       :text
#  meta_description     :string(255)
#  meta_keywords        :string(255)
#  meta_title           :string(255)
#  name_char            :string(255)
#  name_en              :string(255)      default(""), not null
#  name_zh              :string(255)      default(""), not null
#  original_price       :decimal(, )
#  price                :decimal(8, 2)
#  priority             :integer          default(5)
#  published_en         :boolean          default(FALSE)
#  published_zh         :boolean          default(FALSE)
#  sales_volume_totally :integer          default(0)
#  slug                 :string(255)
#  updated_at           :datetime         not null
#  width                :decimal(8, 2)
#
# Indexes
#
#  index_products_on_name_en  (name_en)
#  index_products_on_slug     (slug) UNIQUE
#

FactoryGirl.define do
  factory :product, aliases: [:viewable] do
    name_zh { Forgery(:lorem_ipsum).word }
    name_en { Forgery(:lorem_ipsum).word }
    name_char { Forgery(:lorem_ipsum).character }
    description_en { Forgery(:lorem_ipsum).paragraph }
    description_zh { Forgery(:lorem_ipsum).paragraph }
    inspiration_en { Forgery(:lorem_ipsum).sentence }
    inspiration_zh { Forgery(:lorem_ipsum).sentence }

    count_on_hand { Forgery(:basic).number }

    cost_price { Forgery(:monetary).money }
    price { Forgery(:monetary).money }
    original_price { Forgery(:monetary).money }

    height { Forgery(:basic).number({at_least: 10, at_most: 1000}) }
    width { Forgery(:basic).number({at_least: 10, at_most: 1000}) }
    depth { Forgery(:basic).number({at_least: 10, at_most: 1000}) }

    meta_description { Forgery(:lorem_ipsum).sentence }
    meta_keywords { Forgery(:lorem_ipsum).words(20) }

    trait :available do
      available true
    end

    trait :unavailable do
      available false
    end

    trait :with_collection do
      collection
    end

    trait :with_pics do
      after(:build) do |product|
        create_list(:asset, Forgery(:basic).number, viewable: product )
      end
    end

    # collection_id
    # slug
  end
end
