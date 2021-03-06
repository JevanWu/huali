# == Schema Information
#
# Table name: surveys
#
#  created_at      :datetime         not null
#  gender          :string(255)
#  gift_purpose    :string(255)
#  id              :integer          not null, primary key
#  receiver_age    :string(255)
#  receiver_gender :string(255)
#  relationship    :string(255)
#  updated_at      :datetime         not null
#  user_id         :integer
#

class Survey < ActiveRecord::Base
  belongs_to :user

  extend Enumerize
  enumerize :gender, in: [:male, :female]
  enumerize :receiver_gender, in: [:male, :female]
  enumerize :receiver_age, in: [:eighteen_and_bellow, :nineteen_to_25, :twenty_six_to_40, :forty_one_to_60, :sixty_above]
  enumerize :relationship, in: [:girlfriend, :boyfriend, :wife, :husband, :colleague, :friend, :teacher, :relative, :children, :other_relationship]
  enumerize :gift_purpose, in: [:new_born, :propose, :marriage, :birthday_and_anniversary, :apology, :confession, :business, :wish, :other_purpose]

  validates_presence_of :gender, :receiver_gender, :receiver_age, :relationship, :gift_purpose

  def to_trait_tags
    [receiver_gender, receiver_age, relationship, gift_purpose].sort.join(',')
  end
end
