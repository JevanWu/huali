module TransactionsHelper
  def merchant_trade_link(transaction)
    trade_no = transaction.merchant_trade_no
    if trade_no
      link_to trade_no, "https://merchantprod.alipay.com/trade/refund/fastPayRefund.htm?tradeNo=#{trade_no}&action=detail"
    end
  end

  def transaction_state_shift(transaction)
    case transaction.state
    when "generated"
      link_to(t(:start), start_admin_transaction_path(transaction))
    when "processing"
      link_to(t(:complete), complete_admin_transaction_path(transaction)) + \
      link_to(t(:fail), fail_admin_transaction_path(transaction))
    end
  end
end
