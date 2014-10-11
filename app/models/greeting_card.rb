# == Schema Information
#
# Table name: greeting_cards
#
#  created_at      :datetime
#  id              :integer          not null, primary key
#  product_id      :integer
#  recipient_email :string(255)
#  sender_email    :string(255)
#  sentiments      :text
#  updated_at      :datetime
#  user_id         :integer
#
# Indexes
#
#  index_greeting_cards_on_product_id  (product_id)
#  index_greeting_cards_on_user_id     (user_id)
#

class GreetingCard < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates :sender_email, :recipient_email, presence: true
  validates :sentiments, presence: true, length: { minimum: 5 }
end
