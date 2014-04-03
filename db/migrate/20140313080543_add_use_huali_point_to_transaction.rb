class AddUseHualiPointToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :use_huali_point, :boolean, :default => false
  end
end
