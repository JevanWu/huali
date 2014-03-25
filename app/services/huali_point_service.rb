class HualiPointService

  def self.reward_invitee_point(invitee)
    invitee.edit_huali_point(20) 
    invitee.create_income_point_transaction(20, t("point_transaction.accept_description")) 
  end

  def self.reward_inviter_point(inviter, invitee)
    if inviter
      User.transaction do 
        inviter.lock!
        unless invitee.invitation_rewarded? 
          inviter.edit_invited_and_paid_counter
          inviter.create_income_point_transaction(80, t("point_transaction.refer_description"))
          inviter.edit_huali_point(80)
          invitee.update_column(:invitation_rewarded, true)
        end
      end
    end
  end

  def self.rebate_point(customer, transaction)
    unless transaction.point_transaction
      User.transaction do
        customer.lock!
        customer.edit_huali_point(transaction.amount*0.01)
        customer.create_income_point_transaction(transaction.amount*0.01, transaction.id)
        customer.save!
      end
    end
  end

  def self.minus_expense_point(customer, transaction)
    if transaction.use_huali_point && transaction.point_transaction == nil
      User.transaction do 
        if customer.huali_point > transaction.order.total.to_i
          customer.create_expense_point_transaction(transaction.order.total.to_i, transaction.id)
          customer.edit_huali_point(-transaction.order.total.to_i)
        else
          customer.create_expense_point_transaction(customer.huali_point, transaction.id)
          customer.edit_huali_point(-customer.huali_point)
        end
      end
    end
  end
end
