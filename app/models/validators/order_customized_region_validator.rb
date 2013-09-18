require 'region_rule_runner'

class OrderCustomizedRegionValidator < ActiveModel::Validator
  def validate(order)
    address = order.address

    fetch_policy(order.expected_date).each do |policy|
      if policy.not_open
        order.errors.add :base, :service_not_available
        return
      end

      region_rule = policy.local_region_rule

      if region_rule
        rule_runner = RegionRuleRunner.new(region_rule.province_ids,
                                           region_rule.city_ids,
                                           region_rule.area_ids)

        if !rule_runner.apply_test(address.province_id, address.city_id, address.area_id)
          order.errors.add :base, 
                           :unavailable_location_at_date, 
                           date: order.expected_date
          return
        end
      end
    end
  end

  private 

  def fetch_policy(date)
    PeriodRegionPolicy.available_rules_at_date(date)
  end
end