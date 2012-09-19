class AddUsageandPlaceToProduct < ActiveRecord::Migration
  def change
    add_column :products, :place, :string
    add_column :products, :usage, :string
  end
end
