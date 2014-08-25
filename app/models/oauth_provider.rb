# == Schema Information
#
# Table name: oauth_providers
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  identifier :string(255)
#  provider   :string(255)
#  updated_at :datetime
#  user_id    :integer
#
# Indexes
#
#  index_oauth_providers_on_identifier_and_provider  (identifier,provider) UNIQUE
#  index_oauth_providers_on_user_id                  (user_id)
#

class OauthProvider < ActiveRecord::Base
  belongs_to :user

  validates :identifier, uniqueness: { scope: :provider, message: "the identifier already exists for this provider" }
end
