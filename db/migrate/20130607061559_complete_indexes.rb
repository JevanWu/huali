class CompleteIndexes < ActiveRecord::Migration
  def up
    add_index :recommendation_relations, :product_id
    add_index :recommendation_relations, :recommendation_id

    add_index :addresses, :user_id
    add_index :orders, :user_id
  end

  def down
    remove_index :orders, :user_id
    remove_index :addresses, :user_id

    remove_index :recommendation_relations, :recommendation_id
    remove_index :recommendation_relations, :product_id
  end
end
