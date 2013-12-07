class AddedClientIpToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :client_ip, :string
  end
end
