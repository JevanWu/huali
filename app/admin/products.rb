# encoding: utf-8
require 'kramdown'

ActiveAdmin.register Product do

  {
    :'生效' => :enable!,
    :'无效' => :disable!
  }.each do |label, action|
    batch_action label do |selection|
      products = Product.unscoped.find(selection)
      products.each { |product| product.send(action) }
      redirect_to :back, :notice => "#{products.count}张订单已经更新"
    end
  end
  batch_action :destroy, false

  controller do
    helper :products
    def scoped_collection
      Product.unscoped
    end
  end

  index do
    selectable_column
    column "ID" do |product|
      link_to product.id, product_path(product)
    end

    column "Availability" do |product|
      product.available ?  'yes' : 'no'
    end

    column "Character" do |product|
      link_to "#{product.name_char || ''}", product_path(product)
    end

    column "Cn Name" do |product|
      link_to product.name_zh, product_path(product)
    end

    column "En Name" do |product|
      link_to product.name_en, product_path(product)
    end

    column "Image" do |product|
      unless product.assets.first.nil? or product.assets.first.image.nil?
        image_tag product.assets.first.image.url(:thumb)
      end
    end

    column "Collection" do |product|
      if product.collection
        link_to product.collection.name_cn, collection_path(product.collection)
      end
    end

    # column :original_price, :sortable => :price do |product|
      # div :class => "price" do
        # number_to_currency product.original_price, :unit => '&yen;'
      # end
    # end

    # column :price, :sortable => :price do |product|
      # div :class => "price" do
        # number_to_currency product.price, :unit => '&yen;'
      # end
    # end

    default_actions
  end

  form :partial => "form"

  show do |product|

    attributes_table do
      row :name_zh
      row :name_en
      row :name_char

      row :inspiration_zh do
        markdown(product.inspiration_zh)
      end

      row :inspiration_en do
        markdown(product.inspiration_en)
      end

      row :description_en do
        markdown(product.description_en)
      end

      row :description_zh do
        markdown(product.description_zh)
      end

      row :related_text do
        markdown(product.related_text)
      end

      row :info_source do
        markdown(product.info_source)
      end

      row :collection do
        collection = product.collection
        link_to collection.name_cn, admin_collection_path(collection) if collection
      end

      row :pictures do
        product.assets.map do |asset|
          image_tag asset.image.url(:medium)
        end.join(' ').html_safe
      end

      row :thumbnails do
        product.assets.map do |asset|
          image_tag asset.image.url(:thumb)
        end.join(' ').html_safe
      end

      row :meta_description
      row :meta_keywords
      row :count_on_hand
      row :original_price do
        number_to_currency product.price, :unit => '&yen;'
      end
      row :price do
        number_to_currency product.price, :unit => '&yen;'
      end
      row :cost_price do
        number_to_currency product.cost_price, :unit => '&yen;'
      end
      row :height do
        "#{product.height} cm" if product.height
      end
      row :width do
        "#{product.width} cm" if product.width
      end
      row :depth do
        "#{product.depth} cm" if product.depth
      end
      row :available
      row :created_at
      row :updated_at
    end
  end
end
