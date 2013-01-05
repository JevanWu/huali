class CreateShipMethods < ActiveRecord::Migration
  def change
    create_table :ship_methods do |t|
      t.string :tracking_num
      t.string :name
      t.string :service_phone
      t.string :type
      t.string :website
      t.integer :cost
    end

    add_index :ship_methods, :tracking_num
  end
end
