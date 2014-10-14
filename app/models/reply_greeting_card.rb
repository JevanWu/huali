# == Schema Information
#
# Table name: reply_greeting_cards
#
#  content          :text
#  created_at       :datetime
#  greeting_card_id :integer
#  id               :integer          not null, primary key
#  updated_at       :datetime
#
# Indexes
#
#  index_reply_greeting_cards_on_greeting_card_id  (greeting_card_id)
#

class ReplyGreetingCard < ActiveRecord::Base
end
