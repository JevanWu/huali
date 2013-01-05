class Shipment < ActiveRecord::Base
  attr_accessible :cost, :identifier, :note, :state, :tracking_num, :ship_method_id, :address_id

  belongs_to :address
  belongs_to :ship_method
  belongs_to :order

  before_validation :populate_cost, :copy_address, :generate_identifier, on: :create

  validates_presence_of :order_id, :address_id, :ship_method_id
  validates_presence_of :tracking_num, if: :is_express?

  delegate :method, :to => :ship_method

  def generate_identifier
    self.identifier = uid_prefixed_by('SH')
  end

  def copy_address
    self.address_id = self.order.address_id
  end

  def populate_cost
    self.cost ||= self.ship_method.cost
  end

  private

  def is_express?
    method == 'express'
  end

  def is_mannual?
    method == 'mannual'
  end

end
