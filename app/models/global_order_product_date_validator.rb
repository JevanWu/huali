class GlobalOrderProductDateValidator < ActiveModel::Validator
  def validate(order)
    order_valid = true

    order.products.each do |product|
      next if product.date_rule.present?

      date_rule = Settings.date_rule
      break if date_rule.blank?

      rule_engine_options = {
        range: [date_rule.start_date, date_rule.end_date],
        include: date_rule.included_dates,
        exclude: date_rule.excluded_dates,
        delete_if: Proc.new { |date| date.wday.to_s.in? date_rule.excluded_weekdays }
      }

      date_valid = DateRuleEngine.new(rule_engine_options).apply_test(order.expected_date)

      unless date_valid
        product.errors[:base] = :product_in_unavailable_date

        order_valid && order_valid = false
      end
    end

    order.errors[:base] = :unavailable_date unless order_valid
  end
end
