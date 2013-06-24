class OrderProductDateValidator < ActiveModel::Validator
  def validate(order)
    order_valid = true

    order.products.each do |product|
      raise "No global date_rule settings found" if product.default_date_rule.blank?

      date_rule = merge_rules(product.default_date_rule, product.local_date_rule)

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

  private

  def merge_rules(global_rule, local_rule)
    new_rule = OpenStruct.new

    if local_rule.nil?
      new_rule.start_date = global_rule.start_date.nil? ?
        (Time.current.hour >= 17 ? Date.current.next_day(3) : Date.current.next_day(2))
      :
        global_rule.start_date

      new_rule.end_date = global_rule.end_date.nil? ?
        new_rule.start_date.to_date.next_month
      :
        global_rule.end_date

      new_rule.included_dates = global_rule.included_dates
      new_rule.excluded_dates = global_rule.excluded_dates
      new_rule.excluded_weekdays = global_rule.excluded_weekdays
    else
      # Local rule override global_rule in start dates and end dates
      new_rule.start_date = local_rule.start_date
      new_rule.end_date = local_rule.end_date

      # Union included_dates
      new_rule.included_dates = (global_rule.included_dates | local_rule.included_dates)

      # Union excluded_dates and excluded_weekdays
      new_rule.excluded_dates = (global_rule.excluded_dates | local_rule.excluded_dates)
      new_rule.excluded_weekdays = (global_rule.excluded_weekdays | local_rule.excluded_weekdays)
    end

    new_rule
  end
end
