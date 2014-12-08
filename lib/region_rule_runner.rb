class RegionRuleRunner
  attr_accessor :province_ids, :city_ids, :area_ids

  def initialize(region_rule)
    @province_ids = region_rule.province_ids
    @city_ids = region_rule.city_ids
    @area_ids = region_rule.area_ids
  end

  def apply_test(province_id, city_id, area_id)
    return true if province_ids.blank? && city_ids.blank? && area_ids.blank?

    region_valid = false

    if area_id.present?
      region_valid = true if area_ids.include?(area_id.to_s)
    else
      region_valid = true if city_ids.include?(city_id.to_s)
    end

    region_valid
  end
end
