# encoding: utf-8
class PagesController < ApplicationController

  #caches_page :show, :home, :order, :payment, :alipay, :success

  def show
    @page = Page.find_by_permalink!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  def home
  end

  def share
  end

  private

  def exchange_to_dollar(price)
    amount = (price/6).to_i - 0.01
    amount.to_s
  end

end
