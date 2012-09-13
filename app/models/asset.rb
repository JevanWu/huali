class Asset < ActiveRecord::Base
  belongs_to :viewable, :polymorphic => true
  attr_accessible :image
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>"}

end
