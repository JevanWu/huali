class Story < ActiveRecord::Base
  scope :available, lambda { where(available: true) }
  has_attached_file :picture, :styles => { :medium => "200x185>" }

  default_scope -> { order('created_at DESC') }
end
