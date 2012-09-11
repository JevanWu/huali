class HomeController < ApplicationController
  def index
    @administrators = Administrator.all
  end
end
