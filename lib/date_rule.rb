require 'set'

# rule = lambda { |date| date.monday? }
# DateRule.new(range: ['2013-12-01', '2014-01-02'], exclude: ['2013-11-01', '2013-12-01'], include: ['2013-08-01', '2013-07-01'], keep_if: [ rule ], delete_if: [])

class DateRule
  def initialize(options)
    @start_date, @end_date = init_range(*options[:range])
    @date_set = (@start_date..@end_date).to_set
    exclude_date(options[:exclude])
    include_date(options[:include])
    apply_keep_rules(options[:keep_if])
    apply_delete_rules(options[:delete_if])
  end

  def apply_test(date)
    date = Date.parse(date) unless Date === date
    date.in? @date_set
  end

  private

  def init_range(start_date = nil, end_date = nil)
    start_date ||= '0000-01-01'
    end_date ||= '2099-12-31'
    [ Date.parse(start_date), Date.parse(end_date) ]
  end

  def exclude_date(dates)
    return if dates.nil?
    @date_set.subtract unified_date(dates)
  end

  def include_date(dates)
    return if dates.nil?
    @date_set.merge unified_date(dates)
  end

  def unified_date(dates)
    dates = [dates] unless Array === dates
    dates.map { |date| date.kind_of?(Date) ? date : Date.parse(date) }
  end

  def apply_keep_rules(rules)
    return if rules.nil?
    rules = [rules] unless Array === rules
    @date_set = rules.map do |rule|
      @date_set.dup.keep_if(&rule)
    end.inject(:+)
  end

  def apply_delete_rules(rules)
    return if rules.nil?
    rules = [rules] unless Array === rules
    rules.each do |rule|
      @date_set.delete_if(&rule)
    end
  end
end
