class AdministratorsController < ApplicationController
  before_filter :authenticate_administrator!

  def index
    @administrators = Administrator.all
  end

  def show
    @administrator = Administrator.find(params[:id])
  end
end
