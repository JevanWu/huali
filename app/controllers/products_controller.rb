class ProductsController < ApplicationController

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.available.find(params[:id])

    product_assets  = @product.assets || []

    parts_assets = @product.product_parts.map { |part| part.asset }

    # FIXME cannot use concat here, Raise ActiveRecord::AssociationTypeMismatch
    # might be caused by ActiveRecord Lazy reading
    assets = product_assets + parts_assets

    # filter empty assets
    assets.compact!

    @asset_urls = assets.map do |asset|
      {
        :full_url => asset.image.url,
        :medium_url => asset.image.url(:medium),
        :thumb_url => asset.image.url(:thumb)
      }
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

end
