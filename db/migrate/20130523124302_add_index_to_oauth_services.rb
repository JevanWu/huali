class AddIndexToOauthServices < ActiveRecord::Migration
  def change
    add_index :oauth_services, [:provider, :uid]
  end
end
