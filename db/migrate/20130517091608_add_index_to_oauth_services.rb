class AddIndexToOauthServices < ActiveRecord::Migration
  def change
    add_index :oauth_service, [:provider, :uid]
  end
end
