class CreateShipMethods < ActiveRecord::Migration
  def change
    create_table :ship_methods do |t|
      t.string :name
      t.string :service_phone
      t.string :method
      t.string :website
      t.integer :cost
    end
  end
end
