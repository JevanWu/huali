class ProductsController < ApplicationController
  caches_page :show
  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    @product_parts = @product.product_parts

    product_assets  = @product.assets || []

    parts_assets = @product_parts.map { |part| part.asset }

    # FIXME cannot use concat here, Raise ActiveRecord::AssociationTypeMismatch
    # might be caused by ActiveRecord Lazy reading
    assets = product_assets + parts_assets

    # filter empty assets
    assets.compact!

    @asset_urls = assets.map do |asset|
      {
        :full => asset.image.url,
        :medium => asset.image.url(:medium),
        :thumb => asset.image.url(:thumb)
      }
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

end
