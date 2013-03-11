class AddPrimaryCategoryColumnToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :primary_category, :boolean, null: false, default: false
    Collection.reset_column_information
    Collection.all.each do |c|
      c.primary_category = true
      c.save
    end
  end
end
