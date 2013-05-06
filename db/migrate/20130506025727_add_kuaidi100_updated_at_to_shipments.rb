class AddKuaidi100UpdatedAtToShipments < ActiveRecord::Migration
  def change
    add_column :shipments, :kuaidi100_updated_at, :datetime, :default => Time.at(0)
  end
end
