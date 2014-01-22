class CreateLimitedPromotions < ActiveRecord::Migration
  def change
    create_table :limited_promotions do |t|
      t.string :name
      t.datetime :start_at
      t.datetime :end_at
      t.string :adjustment
      t.references :product
      t.integer :available_count
      t.integer :used_count, default: 0
      t.boolean :expired

      t.timestamps
    end
  end
end
