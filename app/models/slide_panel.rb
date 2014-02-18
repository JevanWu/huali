class SlidePanel < ActiveRecord::Base
  has_many :assets, as: :viewable, dependent: :destroy
  accepts_nested_attributes_for :assets, reject_if: lambda { |a| a[:image].blank? }, allow_destroy: true

  validates :priority, presence: true, uniqueness: true, numericality: {only_integer: true, greater_than: 0}
end
