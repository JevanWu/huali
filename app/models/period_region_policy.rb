class PeriodRegionPolicy < ActiveRecord::Base
  has_one :local_region_rule, as: :region_rulable, dependent: :destroy
  accepts_nested_attributes_for :local_region_rule, allow_destroy: true, update_only: true,
    reject_if: :all_blank

  class << self
    def available_rules_at_date(current_date)
      where('start_date <= ? AND end_date >= ? ',current_date, current_date)
    end
  end
end
