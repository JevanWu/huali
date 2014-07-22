class ProductsController < ApplicationController
  before_action :fetch_collection, only: [:index, :tagged_with]
  before_action :justify_wechat_agent, only: [:show]
  before_action only: :show do
    @menu_nav_type = 'product'
  end

  before_action except: :show do
    @menu_nav_type = 'collection'
  end

  def show
    @product = Product.published.find(params[:id])

    # FIXME products always have assets now
    assets  = @product.assets || []

    # filter empty assets
    assets.compact!

    @asset_urls = assets.map do |asset|
      {
        full: asset.image.url,
        medium: asset.image.url(:medium),
        small: asset.image.url(:small),
        thumb: asset.image.url(:thumb)
      }
    end

    # suggestion
    @related_products = @product.related_products

    if @use_wechat_agent
      # params: target, redirect_url
      @wechat_oauth_url = Wechat::ParamsGenerator.wechat_oauth_url(:code, current_order_url) 
    else
      @wechat_oauth_url = current_order_path
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  def trait
    @products = Product.published
      .tagged_with(params[:tags], on: :traits)
      .page(params[:page]).order_by_priority

    fetch_order_by
  end

  def index
    @products = Product.published.in_collections(@collection_ids).uniq.page(params[:page]).order_by_priority

    prepare_tag_filter
    fetch_order_by

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @products }
    end
  end

  def tagged_with
    @products = Product.published.in_collections(@collection_ids).
      tagged_with(params[:tags], on: :tags).uniq.page(params[:page]).order_by_priority

    prepare_tag_filter
    fetch_order_by

    respond_to do |format|
      format.html { render 'index' }
      format.mobile { render 'index' }
      format.json { render json: @products }
    end
  end

  def search
    @products = Product.solr_search do
      fulltext params[:q]
      with :published, true

      if params[:order].present?
        field, direction = params[:order].scan(/\A(sold_total|price)_?(desc|asc)?\Z/).first
        sort_order = field == "sold_total" ? [:sold_total, :desc] : [field, direction]
        order_by(*sort_order)
      end

      paginate :page => params[:page], :per_page => 12
    end.results

    prepare_tag_filter

    respond_to do |format|
      format.html { render 'search' }
      format.json { render json: @products }
    end
  end

  private

  def fetch_order_by
    if params[:order].present?
      field, direction = params[:order].scan(/^(.*)_(desc|asc)?$/).first

      if field.blank?
        order_by = "sold_total desc"
      else
        order_by = "#{field} #{direction}"
      end

      @products = @products.reorder(order_by)
    end
  end

  def fetch_collection
    @collection = Collection.available.find(params[:collection_id])
    @collection_ids = @collection.self_and_descendants.map(&:id)
  end

  def prepare_tag_filter
    @tag_clouds = Product.published.in_collections(@collection_ids).
      reorder('').tag_counts_on(:tags)
  end
end
