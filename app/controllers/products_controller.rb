require 'kramdown'

class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  def index
    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    md2html = Kramdown::Document.new(@product.description).to_html.html_safe
    @product.description = md2html

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

end
