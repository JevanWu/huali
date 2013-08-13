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
    buttons = case transaction.state
    when "generated"
      link_to(t('models.transaction.state.start'), start_admin_transaction_path(transaction))
    when "processing"
      link_to(t('models.transaction.state.complete'), complete_admin_transaction_path(transaction), data: { confirm: t('views.admin.transaction.confirm_complete') }) + \
      link_to(t('models.transaction.state.failure'), fail_admin_transaction_path(transaction), data: { confirm: t('views.admin.transaction.confirm_fail') })
    end
    content_tag('div', buttons, id: 'process-buttons')
  end
end
