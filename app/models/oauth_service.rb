class OauthService < ActiveRecord::Base
  attr_accessible :user, :provider, :uid

  belongs_to :user

  class << self
    def find_user(provider, uid)
      if o = OauthService.where(provider: provider, :uid => uid).first
        o.user
      end
    end
  end

end
