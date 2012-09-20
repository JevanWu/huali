class ProductPart < ActiveRecord::Base
  attr_accessible :description, :name_cn, :name_en, :asset_attributes, :product_id

  belongs_to :product

  has_one :asset, :as => :viewable, :dependent => :destroy
  attr_accessible :asset
  accepts_nested_attributes_for :asset, :reject_if => lambda { |a| a[:image].blank? }, :allow_destroy => true

  validates :name_cn, :name_en, :presence => true

  def to_s
    "#{self.id} #{self.name_cn}"
  end

end
