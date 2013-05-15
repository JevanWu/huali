class CreateOauthServices < ActiveRecord::Migration
  def change
    create_table :oauth_services do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
