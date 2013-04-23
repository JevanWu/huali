# encoding: utf-8
class AddDefaultKuaidiApiCode < ActiveRecord::Migration
  def up
    table = [
      {name: "EMS", apicode: 'ems'},
      {name: "联邦", apicode: 'lianbangkuaidi'},
      {name: "顺丰", apicode: 'shunfeng'}
    ]

    table.each do |t|
      s = ShipMethod.where(name: t[:name]).first
      s.kuaidi_api_code = t[:apicode]
      s.save
    end
  end

  def down
  end
end
