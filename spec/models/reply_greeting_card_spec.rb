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

require 'spec_helper'

describe ReplyGreetingCard do
  pending "add some examples to (or delete) #{__FILE__}"
end
