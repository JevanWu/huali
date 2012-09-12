class Asset < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :viewable, :polymorphic => true
end
