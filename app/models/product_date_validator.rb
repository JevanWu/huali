class ProductDateValidator < ActiveModel::Validator
  def validate(order)
    order_valid = true

    order.products.each do |product|
      next if product.date_rule.blank?

      date_rule = product.date_rule
      rule_engine_options = {}

      rule_engine_options[:range] = [date_rule.start_date, date_rule.end_date]
      rule_engine_options[:include] = date_rule.included_dates
      rule_engine_options[:exclude] = date_rule.excluded_dates
      rule_engine_options[:delete_if] = Proc.new { |date| date.wday.in? date_rule.excluded_weekdays }

      date_valid = DateRuleEngine.new(rule_engine_options).apply_test(order.expected_date)

      unless date_valid
        product.errors[:base] = :product_in_unavailable_date

        order_valid && order_valid = false
      end
    end

    order.errors[:base] = :unavailable_date unless order_valid
  end
end
