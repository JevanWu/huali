# encoding: utf-8
ActiveAdmin.register Collection do
  menu parent: '产品', if: proc { authorized? :read, Collection }

  sortable tree: true,
           max_levels: 0, # infinite indent levels
           protect_root: false, # allow root items to be dragged
           sorting_attribute: :priority,
           parent_method: :parent,
           children_method: :children,
           roots_method: :roots

  filter :name_zh
  filter :display_name
  filter :description

  controller do

    private

    def permitted_params
      params.permit collection: [:name_en, :name_zh, :display_name, :description, :priority, :available, :primary_category, :meta_title, :meta_description, :meta_keywords, :parent_id]
    end
  end

  index as: :sortable do
    label :display_name
    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :name_zh
      row :display_name
      row :parent
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
