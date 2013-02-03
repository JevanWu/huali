# == Schema Information
#
# Table name: collections
#
#  available        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  description      :string(255)
#  display_name     :string(255)
#  id               :integer          not null, primary key
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  name_en          :string(255)      not null
#  name_zh          :string(255)      not null
#  slug             :string(255)
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_collections_on_slug  (slug) UNIQUE
#

class Collection < ActiveRecord::Base
  attr_accessible :description, :name_en, :name_zh, :display_name,
                  :available, :meta_description, :meta_keywords
  has_many :products

  translate :name

  extend FriendlyId
  friendly_id :name_en, use: :slugged

  scope :available, lambda { where(available: true) }

  def to_s
    "#{self.id} #{self.name_zh}"
  end
end
