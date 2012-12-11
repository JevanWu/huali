class OrdersController < ApplicationController
  layout 'order'
  before_filter :load_cart

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
    @products = []
    @cart.keys.select { |k| k =~ /^\d+$/ }.each do |key|
      if product = Product.find_by_id(key)
        product[:quantity] = @cart[key]
        @products.push product
      end
    end
  end

  private

  def load_cart
    begin
      @cart = JSON.parse(cookies['cart'])
    rescue
      @cart = {}
    end
  end
end
