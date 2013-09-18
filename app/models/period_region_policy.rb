# == Schema Information
#
# Table name: period_region_policies
#
#  created_at :datetime
#  end_date   :date
#  id         :integer          not null, primary key
#  start_date :date
#  updated_at :datetime
#

class PeriodRegionPolicy < ActiveRecord::Base
  has_one :local_region_rule, as: :region_rulable, dependent: :destroy
  accepts_nested_attributes_for :local_region_rule, allow_destroy: true, update_only: true,
    reject_if: :all_blank

  validates_presence_of :start_date, :end_date, :local_region_rule

  class << self
    def available_rules_at_date(current_date)
      where('start_date <= ? AND end_date >= ? ',current_date, current_date).map(&:local_region_rule)
    end
  end
end
