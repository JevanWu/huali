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
    @product_assets  = @product.assets

    @product_parts = @product.product_parts
    @parts_assets = @product_parts.collect do |part|
      part.asset
    end

    @assets = [@product_assets, @parts_assets].flat_map do |asset|
      asset
    end

    @first_medium_url = @assets.first.image.url(:medium)
    @first_url = @assets.first.image.url

    @full_urls = @assets.map do |asset|
      asset.image.url
    end

    @medium_urls = @assets.map do |asset|
      asset.image.url(:medium)
    end

    @thumb_urls = @assets.map do |asset|
      asset.image.url(:thumb)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

end
