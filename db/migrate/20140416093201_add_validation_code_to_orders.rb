class AddValidationCodeToOrders < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        add_column :orders, :validation_code, :string

        Order.find_each do |order|
          order.update_column(:validation_code, order.identifier.gsub(/[a-zA-Z]*/, '').to_i.to_s(16))
        end
      end

      dir.down do
        remove_column :orders, :validation_code
      end
    end
  end
end
