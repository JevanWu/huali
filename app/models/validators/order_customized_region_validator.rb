require 'region_rule_runner'

class OrderCustomizedRegionValidator < ActiveModel::Validator
  def validate(order)
    address = order.address

    Array.new(fetch_rules(order.expected_date)).each do |region_rule|
      rule_runner = RegionRuleRunner.new(region_rule.province_ids,
                                         region_rule.city_ids,
                                         region_rule.area_ids)


      if !rule_runner.apply_test(address.province_id, address.city_id, address.area_id)
        order.errors.add :base, 
                         :unavailable_location_at_date, 
                         date: order.expected_date
        break
      end
    end
  end

  private 

  def fetch_rules(date)

  end
end