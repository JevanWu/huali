# == Schema Information
#
# Table name: products
#
#  count_on_hand          :integer          default(0), not null
#  created_at             :datetime         not null
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
#  index_products_on_default_region_rule_id  (default_region_rule_id)
#  index_products_on_slug                    (slug) UNIQUE
#


class Product < ActiveRecord::Base
  attr_accessible :name_zh, :name_en, :description, :meta_title, :meta_description, :meta_keywords, :count_on_hand, :original_price, :price, :height, :width, :depth, :inspiration, :published, :priority

  attr_accessible :tag_list, :recommendation_ids, :assets, :assets_attributes, :date_rule_attributes, :local_region_rule_attributes

  # collection
  has_and_belongs_to_many :collections
  accepts_nested_attributes_for :collections
  attr_accessible :collection_ids

  # asset
  has_many :assets, as: :viewable, dependent: :destroy
  attr_accessible :assets_attributes
  accepts_nested_attributes_for :assets, reject_if: lambda { |a| a[:image].blank? }, allow_destroy: true

  # lineItems
  has_many :line_items

  # recommendations
  has_many :recommendation_relations
  has_many :recommendations, :through => :recommendation_relations

  # Area and Date rules
  belongs_to :default_region_rule
  has_one :local_region_rule, dependent: :destroy
  accepts_nested_attributes_for :local_region_rule, allow_destroy: true, update_only: true,
    reject_if: :all_blank

  has_one :date_rule, dependent: :destroy
  accepts_nested_attributes_for :date_rule, allow_destroy: true, update_only: true,
    reject_if: proc { |d| d[:start_date].blank? || d[:end_date].blank? }

  # i18n translation
  translate :name

  # validations
  validates_presence_of :name_en, :name_zh, :count_on_hand, :assets, :collections, :default_region_rule

  # scopes
  default_scope lambda { order('priority DESC') }

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
      #FIXME remove try when assert products always have an associated collection
      published.sort_by { |p| p.collection.try(:id) || 0 }
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

  def available_provinces
    possible_city_ids = region_rule.city_ids
    Area.includes(:city).find_all_by_id(region_rule.area_ids).each do |area|
      possible_city_ids << area.city.id unless possible_city_ids.include?(area.city.id)
    end

    available = Province.find_all_by_id(region_rule.province_ids)

    City.includes(:province).find_all_by_id(possible_city_ids).each do |city|
      available << city.province unless available.include?(city.province)
    end

    available
  end

  def available_cities_of_province(province_id)
    available = Province.find(province_id).cities.find_all_by_id(region_rule.city_ids)

    # Append cities of area
    Area.where(parent_post_code: available.map(&:post_code)).find_all_by_id(region_rule.area_ids).map do |area|
      available << area.city unless available.include?(area.city)
    end

    available
  end

  def available_areas_of_city(city_id)
    City.find(city_id).areas.find_all_by_id(region_rule.area_ids)
  end

  def region_rule
    self.local_region_rule || self.default_region_rule
  end
end
