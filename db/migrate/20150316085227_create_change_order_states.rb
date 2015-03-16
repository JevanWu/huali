class CreateChangeOrderStates < ActiveRecord::Migration
  def change
    create_table :change_order_states do |t|
      t.references :administrator, index: true
      t.references :order, index: true
      t.string :order_identifier
      t.string :before_state
      t.string :after_state

      t.timestamps
    end
  end
end
