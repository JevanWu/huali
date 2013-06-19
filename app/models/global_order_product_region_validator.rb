class GlobalOrderProductRegionValidator < ActiveModel::Validator
  def validate(order)
    order_valid = true

    order.products.each do |product|
      next if product.region_rule.present?

      region_rule = Settings.region_rule
      raise "No global region_rule settings found" if region_rule.blank?

      region_rule_engine = RegionRuleEngine.new(region_rule.province_ids,
                                                region_rule.city_ids,
                                                region_rule.area_ids)

      region_valid = region_rule_engine.apply_test(order.address_province_id,
                                                   order.address_city_id,
                                                   order.address_area_id)

      unless region_valid
        product.errors[:base] = :product_in_unavailable_region

        order_valid && order_valid = false
      end
    end

    order.errors[:base] = :unavailable_location unless order_valid
  end
end
