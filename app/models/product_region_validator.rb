class ProductRegionValidator < ActiveModel::Validator
  def validate(order)
    order_valid = true

    order.products.each do |product|
      region_rule_engine = RegionRuleEngine.new(product.province_ids, product.city_ids, product.area_ids)

      region_valid = region_rule_engine.apply_test(order.address.province_id, order.address.city_id, order.address.area_id)

      unless region_valid
        product.errors[:base] = :product_in_unavailable_region

        order_valid && order_valid = false
      end
    end

    order.errors[:base] = :undeliverable_products unless order_valid
  end
end
