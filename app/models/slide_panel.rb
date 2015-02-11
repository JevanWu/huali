# == Schema Information
#
# Table name: slide_panels
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
#  title              :string(255)
#  updated_at         :datetime
#  visible            :boolean          default(FALSE)
#



class SlidePanel < ActiveRecord::Base
  validates :priority, presence: true, numericality: true

  scope :visible, -> { where(visible: true) }
  scope :invisible, -> { where(visible: false) }
  default_scope { order(:priority) }
  
  has_attached_file :image, styles: { medium: "1583x594>", thumb: "266x100>", mobile: "460x173>" }

  def img(size)
    self.image.url(size)
  end
end
