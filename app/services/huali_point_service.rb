class HualiPointService

  def self.reward_point(inviter, invitee)
    User.transaction do 
      inviter.lock!
      unless invitee.invitation_rewarded? 
        inviter.invited_and_paid_counter = inviter.invited_and_paid_counter + 1
        invitee.invitation_rewarded = true
        invitee.save!
      end

      if inviter.invited_and_paid_counter >= 5
        User.transaction do
          inviter.huali_point = inviter.huali_point + 400 
          inviter.point_transactions.create(point: 400, transaction_type: "income", expires_on: Date.current.end_of_year.advance(years: 1))
          inviter.invited_and_paid_counter = inviter.invited_and_paid_counter - 5
          inviter.save!
        end
      end
    end
  end
end
