class Order < ActiveRecord::Base

  attr_accessible :line_items, :address_attributes, :payments_attributes,
                  :line_items_attributes, :address, :number, :special_instructions

  belongs_to :address

  belongs_to :user

  has_many :line_items, :dependent => :destroy, :order => "created_at ASC"
  has_many :payments, :dependent => :destroy
  has_many :shipments, :dependent => :destroy

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :payments
  accepts_nested_attributes_for :shipments

end
