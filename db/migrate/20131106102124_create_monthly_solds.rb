class CreateMonthlySolds < ActiveRecord::Migration
  def change
    create_table :monthly_solds do |t|
      t.integer :sold_year
      t.integer :sold_month
      t.integer :sold_total, default: 0
      t.references :product, index: true

      t.timestamps
    end

    add_index :monthly_solds, [:product_id, :sold_year, :sold_month], unique: true
  end
end
