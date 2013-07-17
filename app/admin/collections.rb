# encoding: utf-8
ActiveAdmin.register Collection do
  menu parent: '产品', if: proc { authorized? :read, Collection }

  filter :name_zh
  filter :display_name
  filter :description

  controller do

    private

    def permitted_params
      params.permit collection: [:name_en, :name_zh, :display_name, :priority, :available, :primary_category, :meta_title, :meta_description, :meta_keywords]
    end
  end

  index do
    selectable_column
    column :name_zh
    column :display_name
    column :name_en
    column :available
    column :primary_category
    column :description
    column :products_count do |collection|
      div class: 'count' do
        collection.products.size
      end
    end
    column :priority
    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :name_zh
      row :display_name
      row :name_en
      row :available
      row :primary_category
      row :description
      row :priority

      row :product do
        collection.products.map do |product|
          link_to product.name, admin_product_path(product)
        end.join(', ').html_safe
      end

      row :meta_title
      row :meta_description
      row :meta_keywords

      row :created_at
      row :updated_at
    end
  end
end
