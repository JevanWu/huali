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

require 'spec_helper'

describe GreetingCard do
  pending "add some examples to (or delete) #{__FILE__}"
end
