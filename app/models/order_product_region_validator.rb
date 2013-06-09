class OrderProductRegionValidator < ActiveModel::Validator
  def validate(order)
    order_valid = true

    order.products.each do |product|
      next if product.region_rule.blank?

      region_rule_engine = RegionRuleEngine.new(product.region_rule.province_ids,
                                                product.region_rule.city_ids,
                                                product.region_rule.area_ids)

      region_valid = region_rule_engine.apply_test(order.address.province_id, order.address.city_id, order.address.area_id)

      unless region_valid
        product.errors[:base] = :product_in_unavailable_region

        order_valid && order_valid = false
      end
    end

    order.errors[:base] = :unavailable_location unless order_valid
  end
end
