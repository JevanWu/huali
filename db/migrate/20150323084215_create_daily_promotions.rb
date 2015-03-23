class CreateDailyPromotions < ActiveRecord::Migration
  def change
    create_table :daily_promotions do |t|
      t.datetime :day
      t.references :product, index: true

      t.timestamps
    end
  end
end
