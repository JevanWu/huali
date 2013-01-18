# == Schema Information
#
# Table name: provinces
#
#  available :boolean          default(FALSE), not null
#  id        :integer          not null, primary key
#  name      :string(255)
#  post_code :integer
#
# Indexes
#
#  index_provinces_on_post_code  (post_code) UNIQUE
#

class Province < ActiveRecord::Base
  # mainly read-only Model
  attr_accessible :available
  scope :available, lambda { where available: true }
  scope :unavailable, lambda { where available: false }

  after_save :update_cities_availability

  has_many :cities, order: 'post_code ASC', foreign_key: 'parent_post_code', primary_key: 'post_code', dependent: :destroy

  has_many :addresses

  validates_presence_of :name, :post_code

  def to_s
    post_code
  end

  def update_cities_availability
    cities.each do |area|
      area.available = available
      area.save
    end
  end
end
