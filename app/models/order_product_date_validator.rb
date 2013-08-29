require 'date_rule_runner'

class OrderProductDateValidator < ActiveModel::Validator
  include OrderProductValidationHelper

  def validate(order)
    order_valid = true

    order.line_items.each do |line_item|
      product = fetch_product(line_item)

      unless validate_product(product, order.expected_date)
        order_valid = false
        line_item.errors.add(:base, :product_in_unavailable_date, product_name: product.name)
      end
    end

    order.errors.add(:expected_date, :unavailable_date) unless order_valid
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
