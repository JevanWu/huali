class Product < ActiveRecord::Base
  attr_accessible :name_cn, :name_en, :description, :meta_description, :meta_keywords, :count_on_hand, :cost_price, :price, :height, :width, :depth, :available_on, :deleted_at, :assets, :assets_attributes

  has_many :assets, :as => :viewable, :dependent => :destroy
  accepts_nested_attributes_for :assets

  validates :name_en, :name_cn, :count_on_hand, :presence => true

  before_save do |product|
    product.name_en.downcase!
  end


  def has_stock?

  end

  def available?

  end

end
