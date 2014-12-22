class AddProductIdToStories < ActiveRecord::Migration
  def change
    add_reference :stories, :product, index: true
  end
end
