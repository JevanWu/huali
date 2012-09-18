class Collection < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :products
end
