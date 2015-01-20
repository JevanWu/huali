class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.string :link
      t.references :collection, index: true
      t.boolean :available, default: true
      t.integer :priority
      t.integer :parent_id

      t.timestamps
    end
  end
end
