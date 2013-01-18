class AddEmailAndPhoneToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :sender_email, :string
    add_column :orders, :sender_phone, :string
    add_column :orders, :sender_name, :string
  end
end
