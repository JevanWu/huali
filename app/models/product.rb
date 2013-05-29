# == Schema Information
#
# Table name: products
#
#  available        :boolean          default(TRUE)
#  count_on_hand    :integer          default(0), not null
#  created_at       :datetime         not null
#  depth            :decimal(8, 2)
#  description      :text
#  height           :decimal(8, 2)
#  id               :integer          not null, primary key
#  inspiration      :text
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  meta_title       :string(255)
#  name_en          :string(255)      default(""), not null
#  name_zh          :string(255)      default(""), not null
#  original_price   :decimal(, )
#  price            :decimal(8, 2)
#  priority         :integer          default(5)
#  published        :boolean          default(FALSE)
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
  attr_accessible :name_zh, :name_en, :description, :meta_title, :meta_description, :meta_keywords, :count_on_hand, :original_price, :price, :height, :width, :depth, :available, :inspiration, :published, :priority

  attr_accessible :tag_list, :recommendation_ids, :assets, :assets_attributes

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

  # i18n translation
  translate :name

  # validations
  validates_presence_of :name_en, :name_zh, :count_on_hand, :assets, :collections

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
    collections.primary.blank? ? collections.primary.first : collections.first
  end

  def category_name
    # FIXME collection should always be contained in a product
    collection.try(:name)
  end

  def has_stock?
    @count_on_hand
  end

  def available?
    @available
  end

  def discount?
    !original_price.nil? && price < original_price
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
