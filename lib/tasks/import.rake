# encoding: utf-8
namespace :import do
  desc "Import Data to Shipments with kuaidi100 API code"
  task shipmethods: :environment do
    table = [
      { name: "EMS", apicode: 'ems' },
      { name: "联邦", apicode: 'lianbangkuaidi' },
      { name: "顺丰", apicode: 'shunfeng' }
    ]

    table.each do |t|
      s = ShipMethod.find_by_name t[:name]
      s.kuaidi_api_code = t[:apicode]
      s.save
    end
  end
end
