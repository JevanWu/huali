class RenameStatusToStateOnTransaction < ActiveRecord::Migration
  def change
    rename_column :transactions, :status, :state
  end
end
