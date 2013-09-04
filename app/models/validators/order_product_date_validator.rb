require 'date_rule_runner'
require_relative 'order_product_base_validator'

class OrderProductDateValidator < OrderProductBaseValidator
  def validate(order)
    super do |line_item, product|
      unless validate_product(product, order.expected_date)
        line_item.errors.add(:base, :product_in_unavailable_date, product_name: product.name)
        order_error ||= :unavailable_date
      end
      [:expected_date, order_error]
    end
  end

  private

  def validate_product(product, expected_date)
    raise "No global date_rule settings found" if product.default_date_rule.blank?
    rule_runner_options = build_rule_runner_options(product.merged_date_rule)
    DateRuleRunner.new(rule_runner_options).apply_test(expected_date)
  end

  def build_rule_runner_options(date_rule)
    {
      range: [date_rule.start_date, date_rule.end_date],
      include: date_rule.included_dates,
      exclude: date_rule.excluded_dates,
      delete_if: Proc.new { |date| date.wday.to_s.in? date_rule.excluded_weekdays }
    }
  end
end
