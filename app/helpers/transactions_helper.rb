module TransactionsHelper
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
