# == Schema Information
#
# Table name: guide_views
#
#  available          :boolean          default(FALSE)
#  created_at         :datetime
#  description        :text
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  priority           :integer
#  updated_at         :datetime
#

class GuideView < ActiveRecord::Base
  validates :priority, presence: true, numericality: true

  default_scope { order(:priority) }

  has_attached_file :image, styles: { medium: "1583x594>", thumb: "266x100>" }

end
