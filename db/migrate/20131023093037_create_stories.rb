class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :name
      t.string :description
      t.boolean :available

      t.timestamps
    end
  end
end
