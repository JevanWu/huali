class HualiPointService

  def self.reward_point(inviter, invitee)
    User.transaction do 
      inviter.lock!
      unless invitee.invitation_rewarded? 
        inviter.edit_invited_and_paid_counter
        invitee.invitation_rewarded = true
        invitee.save!
      end

      if inviter.invited_and_paid_counter >= 5
        User.transaction do
          inviter.edit_huali_point(400)
          inviter.create_income_point_transaction(400)
          inviter.edit_invited_and_paid_counter(-5)
          inviter.save!
        end
      end
    end
  end

  def self.rebate_point(customer, transaction)
    if transaction.point_transaction == nil
      User.transaction do
        customer.lock!
        customer.edit_huali_point(transaction.amount*0.01)
        customer.create_income_point_transaction(transaction.amount*0.01, transaction_id: transaction.id)
        customer.save!
      end
    end
  end

end
