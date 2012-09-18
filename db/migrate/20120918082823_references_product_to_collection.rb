class ReferencesProductToCollection < ActiveRecord::Migration
  def up
    change_table :products do |t|
      t.references :collection
    end
  end

  def down
    change_table :products do |t|
      t.remove_references :collection
    end
  end
end
