require 'date_rule_runner'
require_relative 'order_product_base_validator'

class OrderProductDateValidator < OrderProductBaseValidator
  def validate(order)
    return true if order.instant_delivery

    super do |line_item, product|
      unless validate_product(product, order.expected_date)
        line_item.errors.add(:base, :product_in_unavailable_date, product_name: product.name)
        order_error ||= :unavailable_date
      end

      #if unavailable_provinces_of_valentines_day?(order)
        #line_item.errors.add(:base, :valentines_day_2015, product_name: product.name)
        #order_error ||= :unavailable_date
      #end

      [:expected_date, order_error]
    end
  end

  private

  def validate_product(product, expected_date)
    raise "No global date_rule settings found" if product.default_date_rule.blank?
    rule_runner_options = build_rule_runner_options(product.date_rule)
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

  def unavailable_provinces_of_valentines_day?(order)
    puts order.address.province_id
    #[9,10,11].exclude?(order.address.province_id.to_i) && valentines_day?(order)
    order.address.area_id != 787 and valentines_day?(order)
  end

  def unavailable_area_of_valentines_day?(order)
  end

  def valentines_day?(order)
    ('2015-02-13'.to_date .. '2015-02-14'.to_date).include?(order.expected_date)
  end
end
