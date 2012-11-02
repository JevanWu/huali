class Province < ActiveRecord::Base
  # read-only

  has_many :cities, :order => 'post_code ASC', :foreign_key => 'parent_post_code', :primary_key => 'post_code'

  validates :name, :post_code, :presence => true

  def to_s
    post_code
  end

end
