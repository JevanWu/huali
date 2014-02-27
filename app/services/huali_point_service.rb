class HualiPointService
  def initialize(user)
    @user = user
    @inviter = User.inviter
  end

  def reward_point
    unless @user.invitation_rewarded? 
      @user.invited_and_paid_counter = @user.invited_and_paid_counter + 1
      @user.rewarded = true
    end

    if @user.invited_and_paid_counter >= 5
      @user.lock!
      @user.huali_point = @user.huali_point + 400 
      @user.invited_and_paid_counter - 5
    end
  end
end
