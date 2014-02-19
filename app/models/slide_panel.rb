class SlidePanel < ActiveRecord::Base
  has_many :assets, as: :viewable, dependent: :destroy
  accepts_nested_attributes_for :assets, reject_if: lambda { |a| a[:image].blank? }, allow_destroy: true

  validates :priority, presence: true, uniqueness: true, numericality: {only_integer: true, greater_than: 0}
  
  has_attached_file :image, styles: { medium: "1583x594>", small: "408x153>", thumb: "266x100>" }

  def img(size)
    self.image.url(size)
  end
end
