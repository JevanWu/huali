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
    @appointment = Appointment.new(product: @product)
    @greeting_card = GreetingCard.new(product: @product)
    @reply_greeting_card = ReplyGreetingCard.new

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
    @products = Product.published.in_collections(@collection_ids)
    @products = @products.where(flower_type: params[:flower_type]) if params[:flower_type].present?
    @products = @products.tagged_with(params[:color], on: :colors) if params[:color].present?
    @products = @products.where(price: Range.new(*params[:price_span].split(',').map(&:to_i))) if params[:price_span].present?
    @products = @products.uniq.page(params[:page]).order_by_priority

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

  def appointment
    http_referer = request.env["HTTP_REFERER"]
    if appointment = Appointment.create(appointment_params) 
      redirect_to product_path(appointment.product), flash: { success: t("views.appointment.successful_appointment") }
    else
      redirect_to http_referer, flash: { fail: t("views.appointment.failed_appointment") }
    end
  end

  def greeting_card
    @greeting_card = GreetingCard.new(greeting_card_params) 
    unless user_signed_in?
      unless User.where(email: @greeting_card.sender_email).empty?
        redirect_to( new_user_session_path, alert: t("views.greeting_card.email_registered", email: @greeting_card.sender_email) ) and return
      end
    end
    if @greeting_card.save and Notify.product_greeting_card_email(@greeting_card).deliver
      redirect_to product_path(@greeting_card.product), flash: { success: t("views.greeting_card.succeeded") }
    else
      redirect_to product_path(@greeting_card.product), flash: { fail: t("views.greeting_card.failed") }
    end
  end

  def reply_greeting_card
    @reply_greeting_card = ReplyGreetingCard.new(reply_greeting_card_params)
    if @reply_greeting_card.save and Notify.product_reply_greeting_card_email(@reply_greeting_card).deliver
      redirect_to product_path(@reply_greeting_card.greeting_card.product), flash: { success: t("views.reply_greeting_card.succeeded") }
    else
      redirect_to product_path(@reply_greeting_card.greeting_card.product), flash: { fail: t("views.reply_greeting_card.failed") }
    end
  end

  private

    def appointment_params
      params.require(:appointment).permit(:customer_phone, :customer_email, :user_id, :product_id)
    end

    def greeting_card_params
      params.require(:greeting_card).permit(:sender_email, :recipient_email, :sentiments, :user_id, :product_id, :uuid)
    end

    def reply_greeting_card_params
      params.require(:reply_greeting_card).permit(:response, :greeting_card_id)
    end

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
      @color_tag_clouds = Product.published.in_collections(@collection_ids).
        reorder('').tag_counts_on(:colors)
    end

end
