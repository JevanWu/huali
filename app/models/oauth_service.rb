class OauthService < ActiveRecord::Base
  attr_accessible :provider, :uid

  belongs_to :user

  # FIXME this validator calls some errorr? 
  # validates_presence_of :user

  class << self
    def find_user(provider, uid)
      if o = OauthService.where(provider: provider, uid: uid).first
        o.user
      end
    end
  end

end
