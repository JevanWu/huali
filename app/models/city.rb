# == Schema Information
#
# Table name: cities
#
#  available        :boolean          default(FALSE), not null
#  id               :integer          not null, primary key
#  name             :string(255)
#  parent_post_code :integer
#  post_code        :integer
#
# Indexes
#
#  index_cities_on_post_code  (post_code) UNIQUE
#

class City < ActiveRecord::Base
  scope :available, -> { where available: true }
  scope :unavailable, -> { where available: false }

  after_save :update_areas_availability

  belongs_to :province, foreign_key: 'parent_post_code', primary_key: 'post_code'

  has_many :areas, -> { order('post_code ASC') }, foreign_key: 'parent_post_code', primary_key: 'post_code', dependent: :destroy

  has_many :addresses

  validates :province, :name, :post_code, presence: true

  def to_s
    post_code
  end

  def update_areas_availability
    areas.each do |area|
      area.available = available
      area.save
    end
  end

  def enable
    self.available = true
    self.save
  end

  def disable
    self.available = false
    self.save
  end

  def self.parent_provinces(city_ids)
    City.select("DISTINCT(provinces.id) as province_id").joins(:province).
      where("cities.id in (?)", city_ids).map(&:province_id)
  end
end
