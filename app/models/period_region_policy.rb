class PeriodRegionPolicy < ActiveRecord::Base
  has_one :local_region_rule, as: :region_rulable, dependent: :destroy

  class << self
    def available_rules_at_date(current_date)
      where('start_date <= ? AND end_date >= ? ',current_date, current_date)
    end
  end
end
