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

    product_assets  = @product.assets
    parts_assets = @product.product_parts.collect do |part|
      part.asset
    end

    assets = product_assets + parts_assets

    @asset_urls = assets.map do |asset|
      {
        url: asset.image.url,
        medium_url: asset.image.url(:medium),
        thumbnail_url: asset.image.url(:thumbnail)
      }
    end


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

end
