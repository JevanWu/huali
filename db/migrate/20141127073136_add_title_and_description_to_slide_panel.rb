class AddTitleAndDescriptionToSlidePanel < ActiveRecord::Migration
  def change
    add_column :slide_panels, :title, :string
    add_column :slide_panels, :description, :text
  end
end
