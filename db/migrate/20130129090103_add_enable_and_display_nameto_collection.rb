class AddEnableAndDisplayNametoCollection < ActiveRecord::Migration
  def change
    add_column :collections, :available, :boolean, default: false
    add_column :collections, :display_name, :string
  end
end
