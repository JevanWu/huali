class AddAdministratorToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :administrator, index: true
  end
end
