class AddPromoTagToProduct < ActiveRecord::Migration
  def change
    add_column :products, :promo_tag, :string
  end
end
