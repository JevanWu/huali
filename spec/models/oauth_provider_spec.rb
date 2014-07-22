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
#  index_oauth_providers_on_user_id  (user_id)
#

require 'spec_helper'

describe OauthProvider do
  pending "add some examples to (or delete) #{__FILE__}"
end
