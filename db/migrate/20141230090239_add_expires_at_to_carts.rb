class AddExpiresAtToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :expires_at, :datetime, null: false
  end
end
