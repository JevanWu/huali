# == Schema Information
#
# Table name: orders
#
#  address_id           :integer
#  completed_at         :datetime
#  created_at           :datetime         not null
#  delivery_date        :date             not null
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  payment_total        :decimal(8, 2)    default(0.0)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  special_instructions :text
#  state                :string(255)      default("ready")
#  total                :decimal(8, 2)    default(0.0), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_orders_on_identifier  (identifier) UNIQUE
#

require 'spec_helper'

describe Order do
  pending "add some examples to (or delete) #{__FILE__}"
end
