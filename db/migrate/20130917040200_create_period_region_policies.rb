class CreatePeriodRegionPolicies < ActiveRecord::Migration
  def change
    create_table :period_region_policies do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
