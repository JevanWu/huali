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
  attr_accessible :description, :name_en, :name_zh, :display_name,
                  :available, :meta_description, :meta_keywords
  has_many :products

  extend FriendlyId
  friendly_id :name_en, use: :slugged

  def to_s
    "#{self.id} #{self.name_zh}"
  end
end
