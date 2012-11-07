require 'kramdown'

ActiveAdmin.register Product do

  controller do
    helper :products
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
      link_to product.name_cn, product_path(product)
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
      row :name_cn
      row :name_en
      row :name_char

      row :inspiration do
        markdown(product.inspiration)
      end

      row :description do
        markdown(product.description)
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
