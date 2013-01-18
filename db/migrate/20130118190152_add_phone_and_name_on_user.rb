class AddPhoneAndNameOnUser < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :name, :string
  end
end
