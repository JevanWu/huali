# == Schema Information
#
# Table name: assets
#
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  viewable_id        :integer
#  viewable_type      :string(255)
#
# Indexes
#
#  index_assets_on_viewable_id    (viewable_id)
#  index_assets_on_viewable_type  (viewable_type)
#

class Asset < ActiveRecord::Base
  belongs_to :viewable, polymorphic: true
  attr_accessible :image, :viewable_type
  validates_presence_of :image
  has_attached_file :image, styles: { medium: "310x300>", thumb: "93x90>"}
end
