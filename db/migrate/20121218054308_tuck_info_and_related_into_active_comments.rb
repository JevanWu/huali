class TuckInfoAndRelatedIntoActiveComments < ActiveRecord::Migration
  def change
    remove_column :products, :info_source
    remove_column :products, :related_text
  end
end
