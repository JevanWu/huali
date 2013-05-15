class OauthService < ActiveRecord::Base
  attr_accessible :provider, :uid

  belongs_to :user
end
