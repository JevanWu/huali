# == Schema Information
#
# Table name: shipments
#
#  address_id     :integer
#  cost           :integer
#  created_at     :datetime         not null
#  id             :integer          not null, primary key
#  identifier     :string(255)
#  note           :text
#  order_id       :integer
#  ship_method_id :integer
#  state          :string(255)
#  tracking_num   :string(255)
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_shipments_on_identifier      (identifier)
#  index_shipments_on_order_id        (order_id)
#  index_shipments_on_ship_method_id  (ship_method_id)
#  index_shipments_on_tracking_num    (tracking_num)
#

class Shipment < ActiveRecord::Base
  attr_accessible :cost, :identifier, :note, :state, :tracking_num, :ship_method_id, :address_id, :order_id

  belongs_to :address
  belongs_to :ship_method
  belongs_to :order
  has_one :user, through: :order

  before_validation :populate_cost, :copy_address, :generate_identifier, on: :create
  after_create :ship

  validates_presence_of :order_id, :address_id, :ship_method_id
  validates_presence_of :tracking_num, if: :is_express?

  state_machine :state, :initial => :ready do
    after_transition :to => :completed, :do => :confirm_order
    after_transition :to => :shipped, :do => :ship_order

    # use adj. for state with future vision
    # use v. for event namen
    state :ready do
      transition :to => :shipped, :on => :ship
    end

    # FIXME might need a clock to timeout the processing
    # Might need a bad path for it
    state :shipped do
      transition :to => :completed, :on => :accept
      transition :to => :unknown, :on => :time_out
    end

    state :unknown do
      transition :to => :completed, :on => :accept
    end
  end

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
    ship_method.method == 'express'
  end

  def is_mannual?
    ship_method.method == 'mannual'
  end

  def ship_order
    self.order.ship
  end

  def confirm_order
    self.order.confirm
  end
end
