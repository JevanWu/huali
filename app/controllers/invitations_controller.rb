class InvitationsController < Devise::InvitationsController
  def create
    @from = current_user.email
    @subject = "#{current_user.name.titleize} invited you to checkout Huali"
    self.resource = resource_class.invite!(invite_params, current_user) do |u|
      u.skip_invitation = true
    end

    if resource.email.nil?
      flash[:error] = "Email address is required!"
      redirect_to new_user_invitation_path and return
    end

    resource.deliver_invitation

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email if self.resource.invitation_sent_at
      Notify.delay.invite_message(@from, resource, @subject)
      redirect_to new_user_invitation_path
    else
      respond_with_navigational(resource) { render :new }
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

end
