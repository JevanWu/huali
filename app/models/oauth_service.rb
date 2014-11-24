# == Schema Information
#
# Table name: oauth_services
#
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  oauth_expires_at :datetime
#  oauth_token      :string(255)
#  provider         :string(255)
#  uid              :string(255)
#  updated_at       :datetime         not null
#  user_id          :integer
#
# Indexes
#
#  index_oauth_services_on_provider_and_uid  (provider,uid)
#

class OauthService < ActiveRecord::Base

  # attr_accessible :provider, :uid

  belongs_to :user

  validates_presence_of :user
  validates_presence_of :provider, :uid
  validates :uid, uniquness: true

  class << self
    def find_user(provider, uid)
      OauthService.where(provider: provider, uid: uid.to_s).first.try(:user)
    end
  end
end
