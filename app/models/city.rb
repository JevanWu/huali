class City < ActiveRecord::Base
  # read-only Model

  belongs_to :province, :foreign_key => 'parent_post_code', :primary_key => 'post_code'

  has_many :areas, :order => 'post_code ASC', :foreign_key => 'parent_post_code', :primary_key => 'post_code'

  validates :province, :name, :post_code, :presence => true

  def to_s
    post_code
  end

end
