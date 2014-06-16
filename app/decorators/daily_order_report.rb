class DailyOrderReport
  attr_reader :start_date, :end_date

  private :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date.to_date
    @end_date = end_date.to_date
  end

  def dates
    (start_date..end_date).map(&:to_date)
  end

  def short_dates
    dates.map do |d|
      "\'#{I18n.l d, format: :short}\'"
    end
  end

  def order_amounts_by_date(order_kind)
    the_orders = orders.select { |o| o.kind == order_kind }

    dates.map do |date|
      orders_in_date = the_orders.select { |order| order.created_at.to_date == date }
      if orders_in_date.blank?
        0
      else
        orders_in_date.reduce(0) do |sum, order|
          sum += order_amount(order)
        end
      end
    end
  end

  def order_counts_by_date(order_kind)
    the_orders = orders.select { |o| o.kind == order_kind }

    dates.map do |date|
      orders_in_date = the_orders.select { |order| order.created_at.to_date == date }
      orders_in_date.size
    end
  end

  def total_amount
    orders.reduce(0) do |sum, order|
      sum += order_amount(order)
    end
  end

  def total_count
    orders.size
  end

  def average_order_amount
    return 0 if total_amount.zero?

    (total_amount / total_count).round(2)
  end

private

  def order_amount(order)
    transaction = order.transactions.find { |t| t.state == 'completed' }

    if transaction
      transaction.amount
    else
      0
    end
  end

  def orders
    @orders ||= Order.includes(:transactions).
      where(state: ['wait_make', 'wait_ship', 'wait_confirm', 'completed']).
      where(created_at: start_date..end_date).to_a
  end
end
