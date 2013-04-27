# == Schema Information
#
# Table name: products
#
#  available        :boolean          default(TRUE)
#  cost_price       :decimal(8, 2)
#  count_on_hand    :integer          default(0), not null
#  created_at       :datetime         not null
#  depth            :decimal(8, 2)
#  description_en   :text
#  description_zh   :text
#  height           :decimal(8, 2)
#  id               :integer          not null, primary key
#  inspiration_en   :text
#  inspiration_zh   :text
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  meta_title       :string(255)
#  name_char        :string(255)
#  name_en          :string(255)      default(""), not null
#  name_zh          :string(255)      default(""), not null
#  original_price   :decimal(, )
#  price            :decimal(8, 2)
#  priority         :integer          default(5)
#  published_en     :boolean          default(FALSE)
#  published_zh     :boolean          default(FALSE)
#  slug             :string(255)
#  sold_total       :integer          default(0)
#  updated_at       :datetime         not null
#  width            :decimal(8, 2)
#
# Indexes
#
#  index_products_on_name_en  (name_en)
#  index_products_on_slug     (slug) UNIQUE
#


class Product < ActiveRecord::Base
  attr_accessible :name_zh, :name_en, :intro, :description_zh, :description_en, :description2, :meta_title, :meta_description, :meta_keywords, :count_on_hand, :cost_price, :original_price, :price, :height, :width, :depth, :available, :assets, :assets_attributes, :place, :usage, :inspiration_zh, :inspiration_en, :name_char, :published_en, :published_zh, :tag_list, :priority, :recommendation_ids

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
  has_many :inverse_recommendation_relations, :class_name => "RecommendationRelation", :foreign_key => "recommendation_id"
  has_many :inverse_recommendations, :through => :inverse_recommendation_relations, :source => :product
  attr_accessible :recommendations, :recommendation_relations

  # i18n translation
  translate :name, :description, :inspiration

  # validations
  validates_presence_of :name_en, :name_zh, :count_on_hand, :assets

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
      lang = I18n.locale =~ /zh-CN/ ? 'zh' : I18n.locale
      where(:"published_#{lang}" => true)
    end

    def sort_by_collection
      published.sort_by { |p| p.collection.id }
    end
  end

  def suggested_products(amount = 4, pool = :all, order = :random)
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
    collections.primary.blank? ? collections.primary.first : collections.first
  end

  def has_stock?
    @count_on_hand
  end

  def available?
    @available
  end

  def published?
    lang = I18n.locale =~ /zh-CN/ ? 'zh' : I18n.locale
    self.send("published_#{lang}".to_sym)
  end

  def enable
    self.available = true
    self.save
  end

  def disable
    self.available = false
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
end
