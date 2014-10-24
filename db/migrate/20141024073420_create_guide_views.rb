class CreateGuideViews < ActiveRecord::Migration
  def change
    create_table :guide_views do |t|
      t.text :description
      t.boolean :available, default: false
      t.integer :priority
      t.attachment :image

      t.timestamps
    end
  end
end
