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
  attr_accessible :name, :service_phone, :method, :website, :kuaidi_com_code

  has_many :shipments

  validates_presence_of :name, :method
  validates :method, inclusion: {
    in: %w(express mannual),
    message: "%{value} is not a valid shipment_method."
  }

  def to_s
    name
  end
end
