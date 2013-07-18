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
  attr_accessible :period_length, :excluded_dates, :excluded_weekdays, :included_dates, :start_date, :name

  serialize :included_dates, Array
  serialize :excluded_dates, Array
  serialize :excluded_weekdays, Array
  arrayify_attrs :excluded_dates, :included_dates

  def start_date
    super || (Time.current.hour >= 17 ?
              Date.current.next_day(3) : Date.current.next_day(2))
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

  def merge(other)
    if other.nil?
      self
    else
      OpenStruct.new(
        # Override rule in start and end dates
        start_date: other.start_date,
        end_date: other.end_date,

        # Union included_dates
        included_dates: (self.included_dates | other.included_dates),

        # Union excluded_dates and excluded_weekdays
        excluded_dates: (self.excluded_dates | other.excluded_dates),
        excluded_weekdays: (self.excluded_weekdays | other.excluded_weekdays))
    end
  end
end