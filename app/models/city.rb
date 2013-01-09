# == Schema Information
#
# Table name: cities
#
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
  # read-only Model

  belongs_to :province, :foreign_key => 'parent_post_code', :primary_key => 'post_code'

  has_many :areas, order: 'post_code ASC', foreign_key: 'parent_post_code', primary_key: 'post_code', dependent: :destroy

  has_many :addresses

  validates :province, :name, :post_code, :presence => true

  def to_s
    post_code
  end

end
