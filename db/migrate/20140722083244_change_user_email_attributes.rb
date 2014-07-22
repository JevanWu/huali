class ChangeUserEmailAttributes < ActiveRecord::Migration
  def change
    change_column :users, :email, :string, null: true, unique: true, default: nil
  end
end
