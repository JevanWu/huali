# == Schema Information
#
# Table name: subscriber_emails
#
#  created_at :datetime
#  email      :string(255)
#  id         :integer          not null, primary key
#  updated_at :datetime
#
# Indexes
#
#  index_subscriber_emails_on_email  (email) UNIQUE
#

class SubscriberEmail < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

end
