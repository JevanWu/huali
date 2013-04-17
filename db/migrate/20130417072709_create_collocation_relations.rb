class CreateCollocationRelations < ActiveRecord::Migration
  def change
    create_table :collocation_relations do |t|
      t.integer "product_a_id", :null => false
      t.integer "product_b_id", :null => false
      t.timestamps
    end
  end
end
