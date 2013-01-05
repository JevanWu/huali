class ShipMethod < ActiveRecord::Base
  attr_accessible :name, :service_phone, :method, :website, :cost

  has_many :shipments

  validates_presence_of :cost, :name, :method
  validates :method, inclusion: {
    in: %w(express mannual),
    message: "%{value} is not a valid shipment_method."
  }
end
