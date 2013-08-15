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

class Survey < ActiveRecord::Base
  belongs_to :user

  extend Enumerize
  enumerize :gender, in: [:male, :female]
  enumerize :receiver_gender, in: [:male, :female]
  enumerize :gift_purpose, in: [:lover, :friend, :client, :older, :other]

  validates_presence_of :gender, :receiver_gender, :gift_purpose
end
