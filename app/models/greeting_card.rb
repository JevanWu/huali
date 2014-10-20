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
#  uuid            :string(255)
#
# Indexes
#
#  index_greeting_cards_on_product_id  (product_id)
#  index_greeting_cards_on_user_id     (user_id)
#

class GreetingCard < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  has_many :reply_greeting_cards

  validates :sender_email, :recipient_email, presence: true, format: { with: /\A.*@.*\z/, message: "email format error" }
  validates :sentiments, presence: true
end
