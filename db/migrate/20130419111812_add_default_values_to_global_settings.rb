# encoding: utf-8
class AddDefaultValuesToGlobalSettings < ActiveRecord::Migration
  def change
    GlobalSetting.title = "花里花店"
  end
end
