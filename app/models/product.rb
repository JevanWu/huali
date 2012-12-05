# == Schema Information
#
# Table name: products
#
#  available        :boolean          default(TRUE)
#  collection_id    :integer
#  cost_price       :decimal(8, 2)
#  count_on_hand    :integer          default(0), not null
#  created_at       :datetime         not null
#  depth            :decimal(8, 2)
#  description      :text
#  height           :decimal(8, 2)
#  id               :integer          not null, primary key
#  info_source      :text
#  inspiration      :text
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  name_char        :string(255)
#  name_cn          :string(255)      default(""), not null
#  name_en          :string(255)      default(""), not null
#  original_price   :decimal(, )
#  price            :decimal(8, 2)
#  related_text     :text
#  slug             :string(255)
#  updated_at       :datetime         not null
#  width            :decimal(8, 2)
#
# Indexes
#
#  index_products_on_name_en  (name_en)
#  index_products_on_slug     (slug) UNIQUE
#

class Product < ActiveRecord::Base
  attr_accessible :name_zh, :name_en, :intro, :description_zh, :description_en, :description2, :meta_description, :meta_keywords, :count_on_hand, :cost_price, :original_price, :price, :height, :width, :depth, :available, :assets, :assets_attributes, :collection_id, :place, :usage, :info_source, :inspiration_zh, :inspiration_en, :name_char, :related_text

  # collection
  belongs_to :collection
  accepts_nested_attributes_for :collection
  attr_accessible :collection_id

  # asset
  has_many :assets, :as => :viewable, :dependent => :destroy
  attr_accessible :assets_attributes
  accepts_nested_attributes_for :assets, :reject_if => lambda { |a| a[:image].blank? }, :allow_destroy => true

  # lineItems
  has_many :line_items

  # validations
  validates :name_en, :name_zh, :inspiration_en, :inspiration_zh, :count_on_hand, :presence => true

  # scopes
  #default_scope where(available: true)

  extend FriendlyId
  friendly_id :name_en, use: :slugged

  before_save do |product|
    product.name_en.downcase!
  end

  def has_stock?
    @count_on_hand
  end

  def available?
    @available
  end

  def enable!
    self.available = true
    self.save
  end

  def disable!
    self.available = false
    self.save
  end

  def to_s
    "#{self.id} #{self.name_zh}"
  end

  def name
    case I18n.locale
    when :zh
      self.name_zh
    when :en
      self.name_en
    end
  end

  def inspiration
    case I18n.locale
    when :zh
      self.inspiration_zh
    when :en
      self.inspiration_en
    end
  end

  def description
    case I18n.locale
    when :zh
      self.description_zh
    when :en
      self.description_en
    end
  end
end
