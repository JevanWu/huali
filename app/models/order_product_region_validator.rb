class OrderProductRegionValidator < ActiveModel::Validator
  attr_reader :address

  def validate(order, address = order.address)
    order_valid = true

    order.fetch_products.each do |product|
      unless validate_product(product,
                              address.province_id,
                              address.city_id,
                              address.area_id)
        order_valid = false
        product.errors.add(:base, :product_in_unavailable_region, product_name: product.name)
      end
    end

    unless order_valid
      address.errors.add(:province, :unavailable_location) if address.province_id
      address.errors.add(:city, :unavailable_location) if address.city_id
      address.errors.add(:area, :unavailable_location) if address.area_id
      order.errors.add(:base, :unavailable_location)
    end
  end

  def validate_product(product, province_id, city_id, area_id)
    region_rule = product.region_rule

    raise "No global region_rule settings found" if region_rule.blank?

    rule_runner = RegionRuleRunner.new(region_rule.province_ids,
                                       region_rule.city_ids,
                                       region_rule.area_ids)
    rule_runner.apply_test(province_id, city_id, area_id)
  end
end
