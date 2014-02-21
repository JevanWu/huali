class SlidePanel < ActiveRecord::Base
  validates :priority, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }

  default_scope -> { order(:priority) }
  scope :visible, -> { where(visible: true) }
  
  has_attached_file :image, styles: { medium: "1583x594>", thumb: "266x100>" }

  def img(size)
    self.image.url(size)
  end
end
