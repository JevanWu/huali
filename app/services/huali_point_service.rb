class HualiPointService
  def initialize(user)
    @user = user
    @inviter = User.inviter
  end

  def reward_point
    unless @user.invitation_rewarded? 
      @inviter.invited_and_paid_counter = @inviter.invited_and_paid_counter + 1
      @user.rewarded = true
    end

    if @inviter.invited_and_paid_counter >= 5
      @inviter.lock!
      @inviter.huali_point = @inviter.huali_point + 400 
      @inviter.point_transactions.create(point: 400, transaction_type: "income", expires_on: Date.current.end_of_year.advance(years: 1))
      @inviter.invited_and_paid_counter - 5
    end
  end
end
