class OrdersController < ApplicationController
  layout 'order'

  def index

  end

  def show

  end

  def new
    @order = Order.new
  end

  def create

  end

  def current
    begin
      cart = JSON.parse(cookies['cart'])
    rescue
      cart = {}
    end

    @products = []
    cart.keys.select { |k| k =~ /^\d+$/ }.each do |key|
      if product = Product.find_by_id(key)
        product[:quantity] = cart[key]
        @products.push product
      end
    end
  end
end
