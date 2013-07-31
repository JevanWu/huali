require 'date_rule_runner'

# class Order
#   validates_with OrderProductDateValidator, address: address, items: items
# end
# Configuration options:
# * <tt>:items</tt> - An list of items  (default reads from attributes: record.items)

class OrderProductDateValidator < ActiveModel::Validator
  attr_reader :items

  def initialize(*)
    super
    @items = options[:items]
  end

  def validate(order)
    @items ||= order.fetch_products

    order_valid = true

    items.each do |product|
      unless validate_product(product, order.expected_date)
        order_valid = false
        product.errors.add(:base, :product_in_unavailable_date, product_name: product.name)
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
