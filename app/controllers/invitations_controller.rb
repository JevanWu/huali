class InvitationsController < Devise::InvitationsController
  def create
    @from = "#{current_user.name.titleize} via Huali"
    @subject = "#{current_user.name.titleize} invited you to checkout Huali"
    @user = User.invite!(params[:user], current_user) do |u|
      u.skip_invitation = true
    end

    if @user.invitation_sent_at
      @user.errors[:base] = t("devise.invitations.new.has_been_our_user")
    else
      @user.deliver_invitation
      email =  Notify.invite_message(@user, @from, @subject)
      email.deliver
      flash[:alert] = t("devise.invitations.new.email_sent")
    end
    render :new
  end

  def new
    @selected_menu = :refer_friend
    super
  end
end
