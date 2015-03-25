class CreateAdminOperations < ActiveRecord::Migration
  def change
    create_table :admin_operations do |t|
      t.string :action
      t.references :product, index: true
      t.string :info
      t.string :result
      t.references :administrator, index: true

      t.timestamps
    end
  end
end
