# == Schema Information
#
# Table name: products
#
#  count_on_hand          :integer          default(0), not null
#  created_at             :datetime         not null
#  default_date_rule_id   :integer
#  default_region_rule_id :integer
#  depth                  :decimal(8, 2)
#  description            :text
#  height                 :decimal(8, 2)
#  id                     :integer          not null, primary key
#  inspiration            :text
#  meta_description       :string(255)
#  meta_keywords          :string(255)
#  meta_title             :string(255)
#  name_en                :string(255)      default(""), not null
#  name_zh                :string(255)      default(""), not null
#  original_price         :decimal(, )
#  price                  :decimal(8, 2)
#  priority               :integer          default(5)
#  published              :boolean          default(FALSE)
#  slug                   :string(255)
#  sold_total             :integer          default(0)
#  updated_at             :datetime         not null
#  width                  :decimal(8, 2)
#
# Indexes
#
#  index_products_on_default_date_rule_id    (default_date_rule_id)
#  index_products_on_default_region_rule_id  (default_region_rule_id)
#  index_products_on_slug                    (slug) UNIQUE
#

FactoryGirl.define do
  factory :product, aliases: [:viewable] do
    name_zh { Forgery(:lorem_ipsum).word }
    name_en { Forgery(:lorem_ipsum).word }
    description { Forgery(:lorem_ipsum).paragraph }
    inspiration { Forgery(:lorem_ipsum).sentence }

    priority { Forgery(:basic).number }
    count_on_hand { Forgery(:basic).number }
    sold_total { Forgery(:basic).number({at_least: 1, at_most: 1000}) }

    price { Forgery(:monetary).money }
    original_price { Forgery(:monetary).money }

    height { Forgery(:basic).number({at_least: 10, at_most: 1000}) }
    width { Forgery(:basic).number({at_least: 10, at_most: 1000}) }
    depth { Forgery(:basic).number({at_least: 10, at_most: 1000}) }

    published true

    meta_description { Forgery(:lorem_ipsum).sentence }
    meta_keywords { Forgery(:lorem_ipsum).words(20) }

    default_region_rule
    default_date_rule

    after(:build) do |product|
      [1, 2, 3, 4].sample.times do
        product.assets << create(:asset)
        product.collections << create(:collection)
      end
    end

    trait :with_local_rules do
      after(:create) do |product|
        product.local_date_rule = build(:local_date_rule, product: product)
        product.local_region_rule = build(:local_region_rule, product: product)
      end
    end

    trait :unpublished do
      published false
    end

    # collection_id
    # slug
  end
end
