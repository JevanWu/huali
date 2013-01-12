ActiveAdmin.register Collection do
  menu if: proc { can? :manage, Collection }
  controller.authorize_resource

  filter :name_zh
  filter :description
  filter :created_at
  filter :updated_at

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

  show do
    attributes_table do
      row :name_zh
      row :slug do
        collection.name_en
      end
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
