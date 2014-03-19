class InvitationsController < Devise::InvitationsController
  def create
    @from = current_user.email
    @subject = params[:invite_subject]
    @content = params[:invite_content]
    @user = User.invite!(params[:user], current_user) do |u|
      u.skip_invitation = true
    end

    if !@subject.present? || !@content.present?
      @user.errors[:base] = t("devise.invitations.new.subject_content_not_be_empty")
      render :new and return
    end
    
    if @user.invitation_sent_at
      @user.errors[:base] = t("devise.invitations.new.has_been_our_user")
    else
      @user.deliver_invitation
      email =  Notify.invite_message(@user, @from, @subject, @content)
      email.deliver
      flash[:alert] = t("devise.invitations.new.email_sent")
    end
    render :new
  end
end
