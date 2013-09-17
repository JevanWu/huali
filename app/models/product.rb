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


class Product < ActiveRecord::Base
  attr_accessor :quantity

  # collection
  has_and_belongs_to_many :collections
  accepts_nested_attributes_for :collections

  # asset
  has_many :assets, as: :viewable, dependent: :destroy
  accepts_nested_attributes_for :assets, reject_if: lambda { |a| a[:image].blank? }, allow_destroy: true

  has_attached_file :rectangle_image, styles: { medium: "220x328>" }

  # lineItems
  has_many :line_items

  # recommendations
  has_many :recommendation_relations
  has_many :recommendations, :through => :recommendation_relations

  # Area and Date rules
  belongs_to :default_region_rule
  has_one :local_region_rule, as: :region_rulable, dependent: :destroy
  accepts_nested_attributes_for :local_region_rule, allow_destroy: true, update_only: true,
    reject_if: :all_blank

  belongs_to :default_date_rule
  has_one :local_date_rule, dependent: :destroy
  accepts_nested_attributes_for :local_date_rule, allow_destroy: true, update_only: true,
    reject_if: proc { |d| d[:start_date].blank? }

  # i18n translation
  translate :name

  # validations
  validates_presence_of :name_en, :name_zh, :count_on_hand, :assets, :collections, :price

  # scopes
  default_scope -> { order('priority DESC') }

  extend FriendlyId
  friendly_id :name_en, use: :slugged

  acts_as_taggable

  before_save do |product|
    product.name_en.downcase!
  end

  class << self
    def published
      where(published: true)
    end

    def sort_by_collection
      Product.published.joins(:collections).order('collections.id').to_a.uniq
    end
  end

  def related_products(limit = 5)
    (recommendations.published + suggestions).take(limit)
  end

  def suggestions(amount = 5, pool = :all, order = :random)
    # the pools
    select_pool =
      if pool == :collection && collection
        collection.products.published
      else
        Product.published
      end

    # the ordersing and amount
    if order.in? [:priority, :sold_total]
      select_pool.order(order).limit(amount)
    else
      select_pool.sample(amount)
    end
  end

  def collection
    collections.primary.blank? ? collections.first : collections.primary.first
  end

  def category_name
    # FIXME collection should always be contained in a product
    collection.try(:name)
  end

  def has_stock?
    !!@count_on_hand
  end

  def discount?
    original_price.present? && price < original_price
  end

  def publish
    self.published = true
    self.save
  end

  def unpublish
    self.published = false
    self.save
  end

  def to_s
    "#{self.id} #{self.name_zh}"
  end

  def new?
    created_at >= 2.weeks.ago
  end

  def img(size)
    assets.first.image.url(size)
  end

  def region_rule
    local_region_rule || default_region_rule
  end

  def merged_date_rule
    default_date_rule.merge(local_date_rule)
  end

  def build_local_region_rule_upon_default
    if default_region_rule.present?
      build_local_region_rule(province_ids: default_region_rule.province_ids,
                              city_ids: default_region_rule.city_ids,
                              area_ids: default_region_rule.area_ids)
    else
      build_local_region_rule
    end
  end
end
