class CreateMobileMenus < ActiveRecord::Migration
  def change
    create_table :mobile_menus do |t|
      t.string :name
      t.string :href
      t.text :description
      t.integer :priority
      t.attachment :image

      t.timestamps
    end
  end
end
