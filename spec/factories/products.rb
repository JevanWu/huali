# == Schema Information
#
# Table name: products
#
#  count_on_hand                :integer          default(0), not null
#  created_at                   :datetime         not null
#  default_date_rule_id         :integer
#  default_region_rule_id       :integer
#  delivery                     :text
#  depth                        :decimal(8, 2)
#  description                  :text
#  discountable                 :boolean          default(TRUE)
#  flower_type                  :string(255)
#  height                       :decimal(8, 2)
#  id                           :integer          not null, primary key
#  inspiration                  :text
#  maintenance                  :text
#  material                     :text
#  meta_description             :string(255)
#  meta_keywords                :string(255)
#  meta_title                   :string(255)
#  name_en                      :string(255)      default(""), not null
#  name_zh                      :string(255)      default(""), not null
#  original_price               :decimal(, )
#  price                        :decimal(8, 2)
#  priority                     :integer          default(5)
#  product_type                 :string(255)
#  promo_tag                    :string(255)
#  published                    :boolean          default(FALSE)
#  rectangle_image_content_type :string(255)
#  rectangle_image_file_name    :string(255)
#  rectangle_image_file_size    :integer
#  rectangle_image_updated_at   :datetime
#  sku_id                       :string(255)
#  slug                         :string(255)
#  sold_total                   :integer          default(0)
#  updated_at                   :datetime         not null
#  width                        :decimal(8, 2)
#
# Indexes
#
#  index_products_on_default_date_rule_id    (default_date_rule_id)
#  index_products_on_default_region_rule_id  (default_region_rule_id)
#  index_products_on_print_id                (print_id) UNIQUE
#  index_products_on_slug                    (slug) UNIQUE
#

FactoryGirl.define do
  factory :product, aliases: [:viewable] do
    name_zh { Forgery(:lorem_ipsum).word }
    name_en { Forgery(:lorem_ipsum).word }
    description { Forgery(:lorem_ipsum).paragraph }
    inspiration { Forgery(:lorem_ipsum).sentence }

    priority { Forgery(:basic).number }
    sku_id { Forgery(:basic).number }
    count_on_hand { Forgery(:basic).number + 100 }
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

    rectangle_image_file_name { 'rectangle_image.jpg' }
    rectangle_image_content_type 'image/jpeg'
    rectangle_image_file_size 256

    after(:create) do |product|
      image_file = Rails.root.join("spec/fixtures/#{product.rectangle_image_file_name}")

      # cp test image to direcotries
      [:original, :medium].each do |size|
        dest_path = product.rectangle_image.path(size)
        `mkdir -p #{File.dirname(dest_path)}`
        `cp #{image_file} #{dest_path}`
      end
    end

    after(:build) do |product|
      [1, 2, 3, 4].sample.times do
        product.assets << create(:asset)
        product.collections << create(:collection)
      end
    end

    trait :with_local_rules do
      after(:create) do |product|
        product.local_date_rule = create(:local_date_rule, product: product)
        product.create_local_region_rule
      end
    end

    trait :unpublished do
      published false
    end
  end
end
