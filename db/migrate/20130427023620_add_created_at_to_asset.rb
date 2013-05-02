class AddCreatedAtToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :created_at, :datetime
  end
end
