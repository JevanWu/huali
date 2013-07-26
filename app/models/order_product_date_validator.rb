class OrderProductDateValidator < ActiveModel::Validator
  def validate(order)
    order_valid = true

    order.fetch_products.each do |product|
      unless validate_product(product, order.expected_date)
        order_valid && order_valid = false
      end
    end

    order.errors.add(:expected_date, :unavailable_date) unless order_valid
  end

  private

  def validate_product(product, expected_date)
    raise "No global date_rule settings found" if product.default_date_rule.blank?

    rule_runner_options = build_rule_runner_options(product.merged_date_rule)

    if DateRuleRunner.new(rule_runner_options).apply_test(expected_date)
      true
    else
      product.errors.add(:base, :product_in_unavailable_date, product_name: product.name)
      false
    end
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
