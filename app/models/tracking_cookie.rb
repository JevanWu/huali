# == Schema Information
#
# Table name: tracking_cookies
#
#  created_at   :datetime         not null
#  ga_client_id :string(255)
#  id           :integer          not null, primary key
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_tracking_cookies_on_user_id  (user_id)
#

class TrackingCookie < ActiveRecord::Base
  belongs_to :user
  attr_accessible :ga_client_id
  validates_presence_of :user, :ga_client_id
end
