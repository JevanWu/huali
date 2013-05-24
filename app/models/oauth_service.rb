class OauthService < ActiveRecord::Base

  attr_accessible :provider, :uid

  belongs_to :user

  validates_presence_of :user
  validates_presence_of :provider, :uid

  class << self
    def find_user(provider, uid)
      OauthService.where(provider: provider, uid: uid).first.try(:user)
    end
  end
end
