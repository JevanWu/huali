require 'region_rule_runner'
require_relative 'order_product_base_validator'

class OrderProductRegionValidator < OrderProductBaseValidator
  def validate(order)
    address = order.address
    order_error = nil

    super do |line_item, product|
      unless validate_product(product, address.province_id, address.city_id, address.area_id)
        line_item.errors.add(:base, :product_in_unavailable_region, product_name: product.name)
        order_error ||= :unavailable_location
      end
      [:base, order_error]
    end

    if !!order_error
      address.errors.add(:province_id, :unavailable_location) if address.province_id
      address.errors.add(:city_id, :unavailable_location) if address.city_id
      address.errors.add(:area_id, :unavailable_location) if address.area_id
    end
  end

  def validate_product(product, province_id, city_id, area_id)
    region_rule = product.region_rule

    raise "No global region_rule settings found" if region_rule.blank?

    rule_runner = RegionRuleRunner.new(region_rule)
    rule_runner.apply_test(province_id, city_id, area_id)
  end
end
