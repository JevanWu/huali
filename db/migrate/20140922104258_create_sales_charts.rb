class CreateSalesCharts < ActiveRecord::Migration
  def change
    create_table :sales_charts do |t|
      t.references :product, index: true
      t.integer :position
      t.timestamps
    end
  end
end
