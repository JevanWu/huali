class Area < ActiveRecord::Base
  attr_accessible :name, :post_code

  belongs_to :city, :foreign_key => 'parent_post_code', :primary_key => 'post_code'

  validates :city, :name, :post_code, :presence => true

  def to_s
    post_code
  end

end
