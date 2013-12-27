class AddPriorityToStories < ActiveRecord::Migration
  def change
    add_column :stories, :priority, :integer, default: 0
  end
end
