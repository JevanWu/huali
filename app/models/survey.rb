class Survey < ActiveRecord::Base
  attr_accessible :gender, :gift_purpose, :receiver_gender, :user_id
  belongs_to :user

  extend Enumerize
  enumerize :gender, in: [:male, :female]
  enumerize :receiver_gender, in: [:male, :female]
  enumerize :gift_purpose, in: [:lover, :friend, :client, :older, :other]
end
