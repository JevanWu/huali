class CreateOauthProviders < ActiveRecord::Migration
  def change
    create_table :oauth_providers do |t|
      t.string :identifier
      t.string :provider
      t.references :user, index: true

      t.timestamps
    end

    add_index(:oauth_providers, [:identifier, :provider], unique: true)
  end
end
