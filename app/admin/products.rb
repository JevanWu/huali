# encoding: utf-8
ActiveAdmin.register Product do
  menu parent: '产品', if: proc { authorized? :read, Product }

  [ :publish,
    :unpublish
 ].each do |action|
    batch_action I18n.t(action) do |selection|
      products = Product.find(selection)
      products.each { |product| product.send(action) }
      redirect_to :back, notice: products.count.to_s + t('views.admin.product.product_updated')
    end
  end
  batch_action :destroy, false

  controller do
    helper :products
    before_action :authorize_seo_permission, only: [:create, :update]

    def scoped_collection
      Product.includes(:assets, :collections)
    end

    private

    def authorize_seo_permission
      current_admin_ability.authorize! :update_seo, Product if edit_seo?
    end

    def edit_seo?
      !!params[:product][:meta_title] ||
        !!params[:product][:meta_keywords] ||
        !!params[:product][:meta_description]
    end

    def full_product_fields
      [
        :published,
        :name_zh,
        :name_en,
        :priority,
        :tag_list,
        :trait_list,
        :inspiration,
        :description,
        :count_on_hand,
        :price,
        :original_price,
        :width,
        :depth,
        :height,
        :meta_title,
        :meta_keywords,
        :meta_description,
        :default_date_rule_id,
        :default_region_rule_id,
        :rectangle_image,
        :assets_attributes => [ :id, :image, :_destroy ],
        :collection_ids => [],
        :recommendation_ids => [],
        :local_date_rule_attributes => [:start_date, :period_length, :included_dates, :excluded_dates, { excluded_weekdays: [] }, :_destroy],
        :local_region_rule_attributes => [:province_ids, :city_ids, :area_ids, :_destroy]
      ]
    end

    def permitted_params
      params.permit(product: full_product_fields)
    end
  end

  filter :name_zh
  filter :name_en
  filter :sku_id
  filter :price
  filter :original_price
  filter :tags
  filter :sold_total
  filter :meta_keywords
  filter :meta_title
  filter :meta_description

  index do
    selectable_column
    column "ID" do |product|
      link_to product.sku_id || product.id, product_path(product)
    end

    column :name_zh
    column :name_en

    column :image do |product|
      image_tag product.img(:thumb)
    end

    column :collections do |product|
      product.collections.map do |collection|
        link_to collection.name, admin_collection_path(collection)
      end.join(', ').html_safe
    end

    column :priority

    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :name_zh
      row :name_en
      row :sku_id
      row :published
      row :priority

      row :tag_list
      row :trait_list

      row :sold_total

      row :inspiration do
        markdown(product.inspiration)
      end

      row :description do
        markdown(product.description)
      end

      row :collections do
        product.collections.map do |collection|
          link_to collection.name, admin_collection_path(collection)
        end.join(', ').html_safe
      end

      row :recommendations do
        product.recommendations.map do |product|
          link_to product.name, admin_product_path(product)
        end.join(', ').html_safe
      end

      row :image do
        product.assets.map do |asset|
          image_tag asset.image.url(:medium)
        end.join(' ').html_safe
      end

      row :thumbnail do
        product.assets.map do |asset|
          image_tag asset.image.url(:thumb)
        end.join(' ').html_safe
      end

      row :rectangle_image do
        image_tag product.rectangle_image.url(:medium)
      end

      row :count_on_hand

      row :original_price do
        number_to_currency product.original_price, unit: '&yen;'
      end

      row :price do
        number_to_currency product.price, unit: '&yen;'
      end

      row :height do
        number_to_human(product.height, units: :distance) if product.height
      end

      row :width do
        number_to_human(product.width, units: :distance) if product.width
      end

      row :depth do
        number_to_human(product.depth, units: :distance) if product.depth
      end

      row :created_at
      row :updated_at
    end
  end
end
