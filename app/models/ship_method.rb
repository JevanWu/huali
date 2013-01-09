# == Schema Information
#
# Table name: ship_methods
#
#  cost            :decimal(8, 2)    default(0.0)
#  id              :integer          not null, primary key
#  kuaidi_com_code :string(255)
#  method          :string(255)
#  name            :string(255)
#  service_phone   :string(255)
#  website         :string(255)
#

class ShipMethod < ActiveRecord::Base
  attr_accessible :name, :service_phone, :method, :website, :cost, :kuaidi_com_code

  has_many :shipments

  validates_presence_of :cost, :name, :method
  validates :method, inclusion: {
    in: %w(express mannual),
    message: "%{value} is not a valid shipment_method."
  }
end
