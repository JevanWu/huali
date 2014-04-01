class AddInvitationRelatedFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :invited_and_paid_counter, :integer, :default => 0
    add_column :users, :invitation_rewarded, :boolean, :default => false
    add_column :users, :huali_point, :integer, :default => 0
  end
end
