ActiveAdmin.register Product do

  controller do
    helper :products
  end

  index do
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
        number_to_currency product.price
      end
    end

    column "usage" do |product|
      link_to product.usage, admin_product_path(product)
    end

    column "place" do |product|
      link_to product.place, admin_product_path(product)
    end

  default_actions
  end

  form :partial => "form"

  show do |product|

    attributes_table do
      row :name_cn
      row :name_en
      row :description
      row :collection do
        product.collection.name_cn if product.collection
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
      row :price
      row :cost_price
      row :height
      row :width
      row :depth
      row :available
      row :created_at
      row :updated_at
      row :place do
        if product.place.length
          product.place.slice(1..-1).join(", ")
        end
      end

      row :usage do
        if product.usage.length
          product.usage.slice(1..-1).join(", ")
        end
      end

    end
  end
end
