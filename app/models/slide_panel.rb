class SlidePanel < ActiveRecord::Base
  validates :priority, presence: true, numericality: true

  scope :visible, -> { where(visible: true) }
  
  has_attached_file :image, styles: { medium: "1583x594>", thumb: "266x100>" }

  def img(size)
    self.image.url(size)
  end
end
