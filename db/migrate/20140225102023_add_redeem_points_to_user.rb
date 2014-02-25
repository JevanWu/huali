class AddRedeemPointsToUser < ActiveRecord::Migration
  def change
    add_column :users, :redeem_points, :integer, :default => 0
  end
end
