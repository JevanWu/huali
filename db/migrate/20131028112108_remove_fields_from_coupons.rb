class RemoveFieldsFromCoupons < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        remove_column :coupons, :code
        remove_column :coupons, :available_count
        remove_column :coupons, :used_count
      end

      dir.down do
        add_column :coupons, :code, :string, null: false
        add_column :coupons, :available_count, :integer
        add_column :coupons, :used_count, :integer

        add_index :coupons, :code, unique: true
      end
    end
  end
end
