class Asset < ActiveRecord::Base
  belongs_to :viewable, :polymorphic => true
  attr_accessible :image, :viewable_type
  has_attached_file :image, :styles => { :medium => "310x300>", :thumb => "93x90>"}
end
