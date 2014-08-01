# == Schema Information
#
# Table name: ship_methods
#
#  id                :integer          not null, primary key
#  kuaidi_api_code   :string(255)
#  kuaidi_query_code :string(255)
#  method            :string(255)
#  name              :string(255)
#  service_phone     :string(255)
#  website           :string(255)
#

class ShipMethod < ActiveRecord::Base
  has_many :shipments

  validates_presence_of :name, :method, :kuaidi_query_code
  validates :method, inclusion: {
    in: %w(express manual),
    message: "%{value} is not a valid shipment_method."
  }, allow_blank: true

  def to_s
    name
  end
end
