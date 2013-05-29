class CreateTrackingCookies < ActiveRecord::Migration
  def change
    create_table :tracking_cookies do |t|
      t.references :user
      t.string :ga_client_id

      t.timestamps
    end
    add_index :tracking_cookies, :user_id
  end
end
