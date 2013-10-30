class ChangeCouponReferenceOfOrders < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        rename_column :orders, :coupon_id, :coupon_code_id
        execute <<-SQL.strip_heredoc
          UPDATE orders SET coupon_code_id = (
            SELECT id FROM coupon_codes
            WHERE coupon_id = orders.coupon_code_id
          )
          WHERE coupon_code_id IS NOT NULl
        SQL
      end

      dir.down do
        rename_column :orders, :coupon_code_id, :coupon_id
        execute <<-SQL.strip_heredoc
          UPDATE orders SET coupon_id = (
            SELECT coupon_id FROM coupon_codes
            WHERE id = orders.coupon_id
          )
          WHERE coupon_id IS NOT NULl
        SQL
      end
    end
  end
end
