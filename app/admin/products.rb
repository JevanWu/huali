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
    before_action :setup_rule_params, only: [:create, :update]

    def scoped_collection
      Product.includes(:assets, :collections)
    end

    def permitted_params
      params.require(:product).permit!
    end

    private

    def setup_rule_params
      # For date rule
      params[:product][:local_date_rule_attributes][:included_dates] = params[:product][:local_date_rule_attributes][:included_dates].split(/[,，]/)
      params[:product][:local_date_rule_attributes][:excluded_dates] = params[:product][:local_date_rule_attributes][:excluded_dates].split(/[,，]/)

      # For region rule
      params[:product][:local_region_rule_attributes][:province_ids] = params[:product][:local_region_rule_attributes][:province_ids].split(',')
      params[:product][:local_region_rule_attributes][:city_ids] = params[:product][:local_region_rule_attributes][:city_ids].split(',')
      params[:product][:local_region_rule_attributes][:area_ids] = params[:product][:local_region_rule_attributes][:area_ids].split(',')
    end
  end

  index do
    selectable_column
    column "ID" do |product|
      link_to product.id, product_path(product)
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
      row :published
      row :priority

      row :tag_list

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
    active_admin_comments
  end
end
