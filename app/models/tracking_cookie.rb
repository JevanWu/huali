class TrackingCookie < ActiveRecord::Base
  belongs_to :user
  attr_accessible :ga_client_id
  validates_presence_of :user, :ga_client_id
end
