class Order < ActiveRecord::Base
  belongs_to :address
  belongs_to :user
  attr_accessible :completed_at, :item_total, :number, :payment_state, :payment_total, :shipment_state, :special_instructions, :state, :total
end
