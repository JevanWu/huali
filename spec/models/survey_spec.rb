# == Schema Information
#
# Table name: surveys
#
#  created_at      :datetime         not null
#  gender          :string(255)
#  gift_purpose    :string(255)
#  id              :integer          not null, primary key
#  receiver_gender :string(255)
#  updated_at      :datetime         not null
#  user_id         :integer
#

require 'spec_helper'

describe Survey do
  pending "add some examples to (or delete) #{__FILE__}"
end
