# == Schema Information
#
# Table name: slide_panels
#
#  created_at         :datetime
#  href               :string(255)
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  name               :string(255)
#  priority           :integer
#  updated_at         :datetime
#  visible            :boolean          default(FALSE)
#

class SlidePanel < ActiveRecord::Base
  validates :priority, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }

  default_scope -> { order(:priority) }
  scope :visible, -> { where(visible: true) }
  
  has_attached_file :image, styles: { medium: "1583x594>", thumb: "266x100>" }

  def img(size)
    self.image.url(size)
  end
end
