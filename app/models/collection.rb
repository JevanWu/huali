class Collection < ActiveRecord::Base
  attr_accessible :description, :name_en, :name_cn
  has_many :products

  def to_s
    "#{self.id} #{self.name_cn}"
  end

end
