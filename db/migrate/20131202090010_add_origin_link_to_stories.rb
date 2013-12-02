class AddOriginLinkToStories < ActiveRecord::Migration
  def change
    add_column :stories, :origin_link, :string
  end
end
