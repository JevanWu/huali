class Story < ActiveRecord::Base
  scope :available, lambda { where(available: true) }
  has_attached_file :picture, :styles => { :medium => "150x300>" }

  default_scope -> { order('created_at DESC') }
end
