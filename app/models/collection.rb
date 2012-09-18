class Collection < ActiveRecord::Base
  attr_accessible :description, :name_en, :name_cn
  has_many :products

end
