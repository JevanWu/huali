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

    column "Collection", :collection

    column :price, :sortable => :price do |product|
      div :class => "price" do
        number_to_currency product.price
      end
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

    end
  end
end
