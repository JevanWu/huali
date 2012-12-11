class AddDeliveryDateGiftCardTextToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :gift_card_text, :text
    add_column :orders, :delivery_date, :date, :null => false
  end
end
