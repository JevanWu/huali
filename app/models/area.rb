# == Schema Information
#
# Table name: areas
#
#  available        :boolean          default(FALSE), not null
#  id               :integer          not null, primary key
#  name             :string(255)
#  parent_post_code :integer
#  post_code        :integer
#
# Indexes
#
#  index_areas_on_post_code  (post_code) UNIQUE
#

class Area < ActiveRecord::Base
  # mainly read-only Model
  attr_accessible :available
  scope :available, -> { where available: true }
  scope :unavailable, -> { where available: false }

  belongs_to :city, foreign_key: 'parent_post_code', primary_key: 'post_code'

  has_many :addresses

  validates_presence_of :city, :name, :post_code

  def to_s
    post_code
  end

  def enable
    self.available = true
    self.save
  end

  def disable
    self.available = false
    self.save
  end

  def self.parent_cities(area_ids)
    Area.select("DISTINCT(cities.id) as city_id").joins(:city).
      where("areas.id in (?)", area_ids).map(&:city_id)
  end
end
