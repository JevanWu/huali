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

require 'spec_helper'

describe ShipMethod do
  pending "add some examples to (or delete) #{__FILE__}"
end
