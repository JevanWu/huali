# encoding: utf-8
ActiveAdmin.register Collection do
  menu parent: '产品', if: proc { can? :read, Collection }

  controller do
    include ActiveAdminCanCan
    authorize_resource
  end

  filter :name_zh
  filter :description

  index do
    selectable_column
    column :name_zh do |collection|
      collection.name_zh
    end
    column :description
    column :products_count do |collection|
      div :class => 'count' do
        collection.products.size
      end
    end
    default_actions
  end

  form :partial => "form"

  show do
    attributes_table do
      row :name_zh
      row :name_en
      row :description

      row :product do
        collection.products.map do |product|
          link_to product.name_zh, admin_product_path(product)
        end.join(', ').html_safe
      end

      row :created_at
      row :updated_at
    end
  end
end
