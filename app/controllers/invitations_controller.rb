class InvitationsController < Devise::InvitationsController

  def new
    redirect_to root_path
  end

  def create
    @from = current_user.email
    @subject = "#{current_user.name.titleize} invited you to checkout Huali"

    if invite_params.present?
      skip_invitation

      if self.resource.email.nil?
        render "/users/refer_friend" and return
      end

      send_invitation_email{ redirect_to refer_friend_path }
    else
      if params[:emails]
        params[:emails].each do |email|
          skip_invitation(Hash["email" => email])
          send_invitation_email
        end
        redirect_to account_path
      end
    end
  end

  def update
    self.resource = accept_resource

    #reward huali points
    HualiPointService.reward_invitee_point(self.resource)

    if resource.errors.empty?
      yield resource if block_given?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message :notice, flash_message
      sign_in(resource_name, resource)
      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end

  private

  def skip_invitation(required_params = invite_params)
    self.resource = resource_class.invite!(required_params, current_user) do |u|
      u.skip_invitation = true
    end
  end

  def send_invitation_email
    if self.resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email if self.resource.invitation_sent_at
      self.resource.deliver_invitation
      Notify.delay.invite_message(@from, self.resource, @subject)
      yield if block_given?
    else
      redirect_to :back and return
    end
  end

end
