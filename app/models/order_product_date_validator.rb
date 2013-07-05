class OrderProductDateValidator < ActiveModel::Validator
  def validate(order)
    order_valid = true

    order.fetch_products.each do |product|
      raise "No global date_rule settings found" if product.default_date_rule.blank?

      rule_runner_options = build_rule_runner_options(product.merged_date_rule)
      date_valid = DateRuleRunner.new(rule_runner_options).apply_test(order.expected_date)

      unless date_valid
        product.errors[:base] = :product_in_unavailable_date

        order_valid && order_valid = false
      end
    end

    order.errors.add(:expected_date, :unavailable_date) unless order_valid
  end

  private

  def build_rule_runner_options(date_rule)
    {
      range: [date_rule.start_date, date_rule.end_date],
      include: date_rule.included_dates,
      exclude: date_rule.excluded_dates,
      delete_if: Proc.new { |date| date.wday.to_s.in? date_rule.excluded_weekdays }
    }
  end
end
