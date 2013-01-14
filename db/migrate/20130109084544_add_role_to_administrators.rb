class AddRoleToAdministrators < ActiveRecord::Migration
  def change
    add_column :administrators, :role, :string, default:'admin', null: false
  end
end
