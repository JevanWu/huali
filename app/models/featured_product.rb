# == Schema Information
#
# Table name: featured_products
#
#  available          :boolean          default(TRUE)
#  cover_content_type :string(255)
#  cover_file_name    :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  created_at         :datetime
#  description        :text
#  id                 :integer          not null, primary key
#  priority           :integer
#  product_id         :integer
#  updated_at         :datetime
#
# Indexes
#
#  index_featured_products_on_product_id  (product_id)
#

class FeaturedProduct < ActiveRecord::Base
  belongs_to :product

  validates :product, presence: true

  has_attached_file :cover, :styles => { :medium => "300x300>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/
end
