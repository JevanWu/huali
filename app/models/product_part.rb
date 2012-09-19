class ProductPart < ActiveRecord::Base
  attr_accessible :description, :name_cn, :name_en, :assets_attributes

  belongs_to :product

  has_many :assets, :as => :viewable, :dependent => :destroy
  accepts_nested_attributes_for :assets, :reject_if => lambda { |a| a[:image].blank? }, :allow_destroy => true

  validates :name_cn, :name_en, :presence => true

end
