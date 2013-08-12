class ChangeShipMethodIdTypeOnOrders < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        #change type to integer
        execute <<-SQL
        ALTER TABLE orders 
        ALTER COLUMN ship_method_id 
        TYPE integer 
        USING (trim(ship_method_id)::integer)
        SQL
      end

      dir.down do
        #change type back char(255)
        execute <<-SQL
        ALTER TABLE orders
        ALTER COLUMN ship_method_id 
        TYPE character varying(255) 
        SQL
      end
    end
  end
end
