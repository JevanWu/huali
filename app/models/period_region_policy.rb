class PeriodRegionPolicy < ActiveRecord::Base
  belongs_to :customized_region_rule

  class << self
    def available_rules_at_date(current_date)
      where('start_date <= ? AND end_date >= ? ',current_date, current_date)
    end
  end
end
