class HualiPointService

  def self.reward_point(inviter, invitee)
    if inviter
      User.transaction do 
        inviter.lock!
        unless invitee.invitation_rewarded? 
          inviter.edit_invited_and_paid_counter
          invitee.invitation_rewarded = true
          invitee.save!
          if inviter.invited_and_paid_counter >= 5
            User.transaction do
              inviter.edit_huali_point(400)
              inviter.create_income_point_transaction(400)
              inviter.edit_invited_and_paid_counter(-5)
            end
          end
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
