class CreatePrintGroups < ActiveRecord::Migration
  def change
    create_table :print_groups do |t|
      t.string :name
      t.references :ship_method, index: true

      t.timestamps
    end

    add_index :print_groups, :name, unique: true
  end
end
