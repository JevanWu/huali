class UsersController < ApplicationController
  def show
    if u = User.find_by_email(params[:user_email])
      result = { found: true, email: u.email, name: u.name, phone: u.phone }
    else
      result = { found: false }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end
end
