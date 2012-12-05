class OrdersController < ApplicationController
  layout 'order'

  def index

  end

  def show

  end

  def new

  end

  def create

  end

  def current
    begin
      cart = JSON.parse(cookies['cart'])
    rescue
      cart = {}
    end

    render 'collections/show'
  end
end
