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
  scope :available, lambda { where available: true }
  scope :unavailable, lambda { where available: false }

  belongs_to :city, :foreign_key => 'parent_post_code', :primary_key => 'post_code'

  has_many :addresses

  validates_presence_of :city, :name, :post_code

  def to_s
    post_code
  end

end
