class HualiPointService

  def self.reward_invitee_point(invitee)
    User.transaction do 
      invitee.lock!
      invitee.edit_huali_point(20) 
      invitee.create_income_point_transaction(20, I18n.t("point_transaction.accept_description")) 
    end
  end

  def self.reward_inviter_point(inviter, invitee)
    if inviter
      User.transaction do 
        inviter.lock!
        unless invitee.invitation_rewarded? 
          inviter.edit_invited_and_paid_counter
          inviter.create_income_point_transaction(80, I18n.t("point_transaction.refer_description"))
          inviter.edit_huali_point(80)
          invitee.update_column(:invitation_rewarded, true)
        end
      end
    end
  end

  def self.rebate_point(customer, transaction)
    unless transaction.use_huali_point?
      User.transaction do
        customer.lock!
        customer.create_income_point_transaction(transaction.amount*0.01, I18n.t("point_transaction.rebase_description"), transaction.id)
        customer.edit_huali_point(transaction.amount*0.01)
      end
    end
  end

  def self.minus_expense_point(customer, transaction)
    if transaction.use_huali_point && transaction.point_transaction == nil
      User.transaction do 
        if customer.huali_point > transaction.order.total
          customer.create_expense_point_transaction(transaction.order.total, I18n.t("point_transaction.expense_description"), transaction.id)
          customer.edit_huali_point(-transaction.order.total)
        else
          customer.create_expense_point_transaction(customer.huali_point, I18n.t("point_transaction.expense_description"), transaction.id)
          customer.edit_huali_point(-customer.huali_point)
        end
      end
    end
  end

  def self.process_refund(customer, transaction)
    if transaction.use_huali_point
      User.transaction do
        customer.lock!
        customer.create_income_point_transaction(transaction.point_transaction.point, I18n.t("point_transaction.refund_description"), transaction.id)
        customer.edit_huali_point(transaction.point_transaction.point)
      end
    end
  end
end
