class AddRoleToAdministrators < ActiveRecord::Migration
  def change
    add_column :administrators, :role, :string, null: false
  end
end
