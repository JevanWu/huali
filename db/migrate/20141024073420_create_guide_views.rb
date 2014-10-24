class CreateGuideViews < ActiveRecord::Migration
  def change
    create_table :guide_views do |t|
      t.text :description
      t.string :available, default: false
      t.string :priority
      t.attachment :image

      t.timestamps
    end
  end
end
