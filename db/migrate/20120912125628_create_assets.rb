class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :viewable, :polymorphic => true
    end

    add_index :assets, [:viewable_id], :name => 'index_assets_on_viewable_id'
    add_index :assets, [:viewable_type], :name => 'index_assets_on_viewable_type'
  end

end
