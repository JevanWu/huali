class Survey < ActiveRecord::Base
  attr_accessible :gender, :gift_purpose, :receiver_gender

  extend Enumerize
  enumerize :gender, in: [:male, :female]
  enumerize :receiver_gender, in: [:male, :female]
  enumerize :gift_purpose, in: [:male, :female]
end
