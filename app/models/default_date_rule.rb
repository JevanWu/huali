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

class DefaultDateRule < DateRule
  validates :name, presence: true, uniqueness: true

  def merge(local_date_rule)
    if local_date_rule.nil?
      self
    else
      OpenStruct.new(
        # Local rule override default rule in start and end dates
        start_date: local_date_rule.start_date,
        end_date: local_date_rule.end_date,

        # Union included_dates
        included_dates: (self.included_dates | local_date_rule.included_dates),

        # Union excluded_dates and excluded_weekdays
        excluded_dates: (self.excluded_dates | local_date_rule.excluded_dates),
        excluded_weekdays: (self.excluded_weekdays | local_date_rule.excluded_weekdays))
    end
  end
end
