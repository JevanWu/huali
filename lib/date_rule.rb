require 'active_support/core_ext/object/inclusion'

# Usage
# all params support either date string or Date object
#
# DateRule.new(range: ['2013-12-01', '2014-01-02'])
# DateRule.new(range: ['2013-12-01', '2014-01-02'], exclude: ['2013-11-01', '2013-12-01'])
# DateRule.new(range: ['2013-12-01', '2014-01-02'], include: ['2013-11-01', '2013-12-01'])
#
# more generic rules could be passed to :delete_if or :keep_if
# rule = lambda { |date| date.monday? }
# DateRule.new(range: ['2013-12-01', '2014-01-02'], keep_if: rule)
# DateRule.new(range: ['2013-12-01', '2014-01-02'], delete_if: rule)

class DateRule
  def initialize(options)
    @start_date, @end_date = init_range(*options[:range])
    @date_range = @start_date..@end_date
    @exclude_date = parse_date options[:exclude]
    @include_date = parse_date options[:include]
    @keep_rules = parse_rule options[:keep_if]
    @delete_rules = parse_rule options[:delete_if]
  end

  def apply_test(date)
    date = Date.parse(date) unless Date === date
    return true if @include_date && date.in?(@include_date)
    return false if @exclude_date && date.in?(@exclude_date)

    date.in?(@date_range) && apply_keep_rules(date) && apply_delete_rules(date)
  end

  private

  def init_range(start_date = nil, end_date = nil)
    start_date ||= '0000-01-01'
    end_date ||= '2099-12-31'
    [ Date.parse(start_date), Date.parse(end_date) ]
  end

  def parse_date(dates)
    return nil if dates.nil?
    dates = [dates] unless Array === dates
    dates.map { |date| date.kind_of?(Date) ? date : Date.parse(date) }
  end

  def parse_rule(rules)
    return nil if rules.nil?
    rules = [rules] unless Array === rules
    rules
  end

  def apply_keep_rules(date)
    return true if @keep_rules.nil?
    for rule in @keep_rules
      return true if rule.call(date)
    end
    false
  end

  def apply_delete_rules(date)
    return true if @delete_rules.nil?
    for rule in @delete_rules
      return false if rule.call(date)
    end
    true
  end
end
