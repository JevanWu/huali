class CreateRedeems < ActiveRecord::Migration
  def change
    create_table :redeems do |t|
      t.string :title
      t.integer :cost_points
      t.references :user, index: true
      t.references :order, index: true

      t.timestamps
    end
  end
end
