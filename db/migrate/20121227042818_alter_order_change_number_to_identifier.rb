class AlterOrderChangeNumberToIdentifier < ActiveRecord::Migration
  def change
    rename_column :orders, :number, :identifier
  end
end
