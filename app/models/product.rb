# == Schema Information
#
# Table name: products
#
#  count_on_hand                :integer          default(0), not null
#  created_at                   :datetime         not null
#  default_date_rule_id         :integer
#  default_region_rule_id       :integer
#  depth                        :decimal(8, 2)
#  description                  :text
#  discountable                 :boolean          default(TRUE)
#  flower_type                  :string(255)
#  height                       :decimal(8, 2)
#  id                           :integer          not null, primary key
#  inspiration                  :text
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
#  index_products_on_slug                    (slug) UNIQUE
#

class Product < ActiveRecord::Base
  extend Enumerize

  paginates_per 12

  attr_accessor :quantity

  # collection
  has_and_belongs_to_many :collections
  accepts_nested_attributes_for :collections

  # appointment
  has_many :appointments, dependent: :destroy
  
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

  has_many :monthly_solds

  has_many :limited_promotions

  # i18n translation
  translate :name

  # validations
  validates_presence_of :name_en, :name_zh, :count_on_hand, :assets, :collections, :price
  enumerize :product_type, in: [:fresh_flower, :preserved_flower, :others, :fake_flower, :perfume], default: :others
  enumerize :promo_tag, in: [:limit]
  enumerize :flower_type, in: [:flower_box, :holding_flower, :photo_frame_flower, :bonsai, :others], default: :flower_box

  # scopes
  scope :order_by_priority, -> { order('priority DESC') }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :in_collections, ->(collection_ids) do
    joins(:collections).where("collections_products.collection_id in (?)", collection_ids)
  end

  extend FriendlyId
  friendly_id :name_en, use: :slugged

  acts_as_taggable
  acts_as_taggable_on :traits
  acts_as_taggable_on :colors

  before_save do |product|
    product.name_en.downcase!
  end

  before_save :notify_customers

  after_initialize do |product|
    product.discountable = true if product.discountable.nil?
  end

  searchable do
    text :name_en, :name_zh, boost: 5.0
    text :product_type_text, boost: 3.0
    text :flower_type_text, boost: 3.0
    text :price, boost: 2.0 do
      price.to_i
    end
    text :collections do
      collections.map(&:display_name)
    end

    text :description

    integer :sold_total
    double :price
    boolean :published

    string :flower_type
  end

  class << self
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
    count_on_hand > 0
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

  def date_rule
    local_date_rule || default_date_rule
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

  def update_monthly_sold(quantity, date=Date.current)
    month_sold(date).update_sold_total(quantity)

    if date == Date.current
      update_column(:sold_total, month_sold(date).sold_total)
    end
  end

  def limited_promotion_today
    limited_promotions.start_today.first
  end

  def month_sold(date)
    ret = monthly_solds.by_date(date).first

    begin
      ret ||= monthly_solds.create(sold_year: date.year, sold_month: date.month)
    rescue ActiveRecord::RecordNotUnique
      ret = monthly_solds.by_date(date).first
    end

    ret
  end

  def update_stock(sold_count)
    update_column(:count_on_hand, [count_on_hand - sold_count, 0].max)
  end

  private

    def notify_customers
      if self.changed.include?("count_on_hand") && self.count_on_hand > 0
        Notify.delay.notify_appointment(self)
        Notify.deplay.product_appointment_email(self.id)
        Sms.delay.product_appointment_sms(self.id)
      end
    end
end
