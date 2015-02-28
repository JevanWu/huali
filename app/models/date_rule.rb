# == Schema Information
#
# Table name: date_rules
#
#  created_at        :datetime         not null
#  excluded_dates    :text
#  excluded_weekdays :string(255)
#  id                :integer          not null, primary key
#  included_dates    :text
#  name              :string(255)
#  period_length     :string(255)
#  product_id        :integer
#  start_date        :date
#  type              :string(255)
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_date_rules_on_product_id  (product_id)
#



class DateRule < ActiveRecord::Base
  serialize :included_dates, Array
  serialize :excluded_dates, Array
  serialize :excluded_weekdays, Array
  arrayify_attrs :excluded_dates, :included_dates

  def self.get_rules_by(date)
    area_id = area_id.to_s
    arr = []
    find_each { |r| arr << r if r.valid_date?(date) }
    arr
  end

  def valid_date?(date)
    DateRuleRunner.new(build_rule_runner_options).apply_test(date)
  end
  def build_rule_runner_options
    {
      range: [start_date, end_date],
      include: included_dates,
      exclude: excluded_dates,
      delete_if: Proc.new { |date| date.wday.to_s.in? excluded_weekdays }
    }
  end

  def start_date
    if Setting.date_rule_start_date.present? && Setting.date_rule_start_date.to_date >= Date.current
      Setting.date_rule_start_date
    else
      super || (Time.current.hour >= 17 ? Date.current.next_day(2) : Date.current.next_day(1))
    end
  end

  def end_date
    case
    when period_length =~ /\+(\d+)Y/
      start_date.next_year($1.to_i)
    when period_length =~ /\+(\d+)M/
      start_date.next_month($1.to_i)
    when period_length =~ /\+(\d+)D/
      start_date.next_day($1.to_i)
    else
      start_date.next_month(2)
    end
  end
end
