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
  # read-only

  has_many :cities, order: 'post_code ASC', foreign_key: 'parent_post_code', primary_key: 'post_code', dependent: :destroy

  has_many :addresses

  validates :name, :post_code, :presence => true

  def to_s
    post_code
  end

end
