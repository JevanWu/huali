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
end
