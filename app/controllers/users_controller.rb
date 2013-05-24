class UsersController < ApplicationController
  def check_user_exist
    if u = User.find_by_email(params[:user_email])
      result = { found: true, email: u.email }
    else
      result = { found: false }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end
end
