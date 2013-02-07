module TransactionsHelper
  def transaction_state_class(transaction)
    case transaction.state
    when 'generated'
      ''
    when 'processing'
      'warning'
    when 'completed'
      'ok'
    when 'failure'
      'error'
    else
    end
  end

  def transaction_state_shift(transaction)
    case transaction.state
    when "generated"
      link_to(t(:start, :scope => :transaction), start_admin_transaction_path(transaction))
    when "processing"
      link_to(t(:complete, :scope => :transaction), complete_admin_transaction_path(transaction), confirm: t(:confirm_complete)) + \
      link_to(t(:failure, :scope => :transaction), fail_admin_transaction_path(transaction), confirm: t(:confirm_fail))
    end
  end
end
