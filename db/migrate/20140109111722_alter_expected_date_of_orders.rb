class AlterExpectedDateOfOrders < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        change_column :orders, :expected_date, :date, null: true
      end

      dir.down do
        change_column :orders, :expected_date, :date, null: false
      end
    end
  end
end
