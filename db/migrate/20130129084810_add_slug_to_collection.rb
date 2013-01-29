class Collection < ActiveRecord::Base
end

class AddSlugToCollection < ActiveRecord::Migration
  def up
    add_column :collections, :slug, :string
    add_index :collections, :slug, unique: true
    Collection.find_each(&:save)
  end

  def down
    remove_column :collections, :slug
    remove_index :collections, :slug
  end
end
