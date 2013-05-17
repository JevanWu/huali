class AddOauthTokenToOauthServices < ActiveRecord::Migration
  def change
    add_column :oauth_services, :oauth_token, :string
    add_column :oauth_services, :oauth_expires_at, :datetime
  end
end
