ActiveAdmin.register DiscountEvent do
  menu parent: '设置', if: proc { authorized? :read, DiscountEvent}

  controller do
    def permitted_params
      params.permit(discount_event: [:discount_date, :product_id, :original_price, :price])
    end
  end

  form partial: "form"

  filter :discount_date
  filter :original_price
  filter :price

  index do
    selectable_column
    column :product do |discount_event|
      discount_event.product.name
    end

    column :discount_date
    column :original_price
    column :price

    default_actions
  end

  show do
    attributes_table do
      row :product do |discount_event|
        discount_event.product.name
      end
      row :discount_date
      row :original_price
      row :price
      row :created_at
      row :updated_at
    end
  end
end
