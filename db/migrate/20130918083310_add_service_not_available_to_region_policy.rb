class AddServiceNotAvailableToRegionPolicy < ActiveRecord::Migration
  def change
    add_column :period_region_policies, :not_open, :boolean
  end
end