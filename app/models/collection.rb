# == Schema Information
#
# Table name: collections
#
#  created_at  :datetime         not null
#  description :string(255)
#  id          :integer          not null, primary key
#  name_en     :string(255)      not null
#  name_zh     :string(255)      not null
#  updated_at  :datetime         not null
#

class Collection < ActiveRecord::Base
  attr_accessible :description, :name_en, :name_cn
  has_many :products

  def to_s
    "#{self.id} #{self.name_zh}"
  end

end
