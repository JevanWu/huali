class CreateRecommendationRelations < ActiveRecord::Migration
  def change
  	create_table :recommendation_relations do |t|
  	  t.integer :product_id
  	  t.integer :recommendation_id
  	  t.timestamps
  	end
  end
end
