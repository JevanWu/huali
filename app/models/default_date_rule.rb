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

  def self.get_rules_by(date)
    all.select { |e| e.valid_date?(date) }
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
end
