class AddIntroToProduct < ActiveRecord::Migration
  def change
    add_column :products, :intro, :string
  end
end
