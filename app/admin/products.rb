ActiveAdmin.register Product do

  controller do
    helper :products
  end

  index do
    selectable_column
    column "Image" do |product|
      unless product.assets.first.nil? or product.assets.first.image.nil?
        image_tag product.assets.first.image.url(:thumb)
      end
    end

    column "Chinese Name" do |product|
      link_to product.name_cn, admin_product_path(product)
    end

    column "English Name" do |product|
      link_to product.name_en, admin_product_path(product)
    end

    column "Count", :count_on_hand

    column "Collection" do |product|
      if product.collection
        link_to product.collection.name_cn, admin_collection_path(product.collection)
      end
    end

    column :price, :sortable => :price do |product|
      div :class => "price" do
        number_to_currency product.price, :unit => '&yen;'
      end
    end

    column "usage" do |product|
      unless product.usage.nil?
        product.usage.slice(1..-1).join(", ")
      end
    end

    column "place" do |product|
      unless product.place.nil?
        product.place.slice(1..-1).join(", ")
      end
    end

  default_actions
  end

  form :partial => "form"

  show do |product|

    attributes_table do
      row :name_cn
      row :name_en
      row :description do
        Kramdown::Document.new(product.description).to_html.html_safe
      end

      row :collection do
        collection = product.collection
        link_to collection.name_cn, admin_collection_path(collection) if collection
      end

      row :parts do
        product.product_parts.map do |product_part|
          link_to product_part.name_cn, admin_product_part_path(product_part)
        end.join(', ').html_safe
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
      row :place do
        unless product.place.nil?
          product.place.slice(1..-1).join(", ")
        end
      end

      row :usage do
        unless product.usage.nil?
          product.usage.slice(1..-1).join(", ")
        end
      end

    end
  end
end
