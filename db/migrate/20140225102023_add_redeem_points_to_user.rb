class AddRedeemPointsToUser < ActiveRecord::Migration
  def change
    add_column :users, :redeem_points, :integer
  end
end
