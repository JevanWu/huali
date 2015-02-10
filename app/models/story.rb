# == Schema Information
#
# Table name: stories
#
#  author_avatar_content_type :string(255)
#  author_avatar_file_name    :string(255)
#  author_avatar_file_size    :integer
#  author_avatar_updated_at   :datetime
#  available                  :boolean
#  created_at                 :datetime
#  description                :string(255)
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  origin_link                :string(255)
#  picture_content_type       :string(255)
#  picture_file_name          :string(255)
#  picture_file_size          :integer
#  picture_updated_at         :datetime
#  priority                   :integer          default(0)
#  product_id                 :integer
#  product_link               :string(255)
#  updated_at                 :datetime
#
# Indexes
#
#  index_stories_on_product_id  (product_id)
#



class Story < ActiveRecord::Base
  scope :available, lambda { where(available: true) }
  scope :unavailable, lambda { where(available: false) }

  has_attached_file :picture, :styles => { :medium => "200x485>" }
  has_attached_file :author_avatar, :styles => { :small => "40x40>" }
end
