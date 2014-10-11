# == Schema Information
#
# Table name: mobile_menus
#
#  created_at         :datetime
#  description        :text
#  href               :string(255)
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  name               :string(255)
#  priority           :integer
#  updated_at         :datetime
#

class MobileMenu < ActiveRecord::Base
  validates_presence_of :name, :image

  has_attached_file :image, styles: { medium: "400x200>", thumb: "100x50>" }
end
