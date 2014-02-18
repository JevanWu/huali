class CreateSlidePanels < ActiveRecord::Migration
  def change
    create_table :slide_panels do |t|
      t.string :name
      t.string :href
      t.integer :priority
      t.boolean :visible, :default => false

      t.timestamps
    end
  end
end
