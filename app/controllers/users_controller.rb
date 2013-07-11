class UsersController < ApplicationController
  respond_to :json

  def check_user_exist
    if u = User.find_by_email(check_user_params)
      result = { found: true, email: u.email }
    else
      result = { found: false }
    end

    respond_with(result)
  end

  private

  def check_user_params
    params.require(:user_email)
  end
end
