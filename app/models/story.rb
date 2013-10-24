class Story < ActiveRecord::Base
  scope :available, lambda { where(available: true) }
  has_attached_file :picture, :styles => { :medium => "200x185>" }
  has_attached_file :author_avatar, :styles => { :small => "40x40>" }

  default_scope -> { order('created_at DESC') }
end
