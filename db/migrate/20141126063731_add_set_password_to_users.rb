class AddSetPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :set_password, :boolean, default: true
  end
end
