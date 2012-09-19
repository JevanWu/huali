ActiveAdmin.register Collection do
  index do
    column :name_cn
    column :name_en
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
      row :name_cn
      row :name_en
      row :description

      row :product do
        collection.products.map do |product|
          link_to product.name_cn, admin_product_path(product)
        end.join(', ').html_safe
      end

      row :created_at
      row :updated_at
    end
  end
end
