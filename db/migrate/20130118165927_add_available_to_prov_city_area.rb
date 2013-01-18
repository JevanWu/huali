class AddAvailableToProvCityArea < ActiveRecord::Migration
  def change
    add_column :provinces, :available, :boolean, default: false, null: false
    add_column :cities, :available, :boolean, default: false, null: false
    add_column :areas, :available, :boolean, default: false, null: false
  end
end
