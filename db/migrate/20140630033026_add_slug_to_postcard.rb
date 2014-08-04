class AddSlugToPostcard < ActiveRecord::Migration
  def change
    add_column :postcards, :slug, :string
  end
end
