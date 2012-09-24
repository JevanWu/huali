class Product < ActiveRecord::Base
  attr_accessible :name_cn, :name_en, :description, :meta_description, :meta_keywords, :count_on_hand, :cost_price, :price, :height, :width, :depth, :available, :assets, :assets_attributes, :collection_id, :place, :usage

  # collection
  belongs_to :collection
  accepts_nested_attributes_for :collection
  attr_accessible :collection_id

  # asset
  has_many :assets, :as => :viewable, :dependent => :destroy
  attr_accessible :assets_attributes
  accepts_nested_attributes_for :assets, :reject_if => lambda { |a| a[:image].blank? }, :allow_destroy => true

  # productPart
  has_many :product_parts, :dependent => :destroy
  attr_accessible :product_parts_attributes
  accepts_nested_attributes_for :product_parts,
    :reject_if => lambda { |a| a[:name_cn].blank? or a[:name_en].blank? }, :allow_destroy => true

  validates :name_en, :name_cn, :count_on_hand, :presence => true

  before_save do |product|
    product.name_en.downcase!
  end

  def has_stock?
    @count_on_hand
  end

  def available?
    @available
  end

  def to_s
    "#{self.id} #{self.name_cn}"
  end

end
