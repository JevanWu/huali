class AddDisplayOnBreadcrumbToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :display_on_breadcrumb, :boolean, default: false
  end
end
