# encoding: utf-8
ActiveAdmin.register Product do
  menu parent: '产品', if: proc { authorized? :read, Product }

  [ :enable,
    :disable
 ].each do |action|
    batch_action I18n.t(action) do |selection|
      products = Product.unscoped.find(selection)
      products.each { |product| product.send(action) }
      redirect_to :back, notice: products.count.to_s + t('views.admin.product.product_updated')
    end
  end
  batch_action :destroy, false

  scope_to do
    Class.new do
      def self.products
        Product.unscoped
      end
    end
  end

  controller do
    helper :products
    def scoped_collection
      Product.unscoped.includes(:assets, :collections)
    end
  end

  index do
    selectable_column
    column "ID" do |product|
      link_to product.id, product_path(product)
    end

    column :name_zh
    column :name_en

    column :available do |product|
      product.available ?  t('views.admin.product.available') : t('views.admin.product.unavailable')
    end

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
      row :available
      row :published_zh
      row :published_en
      row :priority

      row :tag_list

      row :inspiration_zh do
        markdown(product.inspiration_zh)
      end

      row :inspiration_en do
        markdown(product.inspiration_en)
      end

      row :description_zh do
        markdown(product.description_zh)
      end

      row :description_en do
        markdown(product.description_en)
      end

      row :collections do
        product.collections.map do |collection|
          link_to collection.name, admin_collection_path(collection)
        end.join(', ').html_safe
      end

      row :recommendation do
        product.recommendation_ids.join(',').html_safe
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
        number_to_currency product.price, unit: '&yen;'
      end

      row :price do
        number_to_currency product.price, unit: '&yen;'
      end

      row :cost_price do
        number_to_currency product.cost_price, unit: '&yen;'
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
