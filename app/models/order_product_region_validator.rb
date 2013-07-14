class OrderProductRegionValidator < ActiveModel::Validator
  def validate(order)
    order_valid = true

    order.fetch_products.each do |product|
      region_rule = product.region_rule

      raise "No global region_rule settings found" if region_rule.blank?

      region_rule_engine = RegionRuleRunner.new(region_rule.province_ids,
                                                region_rule.city_ids,
                                                region_rule.area_ids)

      region_valid = region_rule_engine.apply_test(order.address_province_id,
                                                   order.address_city_id,
                                                   order.address_area_id)

      unless region_valid
        product.errors.add(:base, :product_in_unavailable_region, product_name: product.name)

        order_valid && order_valid = false
      end
    end

    unless order_valid
      order.address.errors.add(:province, :unavailable_location) if order.address.province
      order.address.errors.add(:city, :unavailable_location) if order.address.city
      order.address.errors.add(:area, :unavailable_location) if order.address.area
      order.errors.add(:base, :unavailable_location)
    end
  end
end
