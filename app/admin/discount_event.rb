ActiveAdmin.register DiscountEvent do
  menu parent: '设置', if: proc { authorized? :read, DiscountEvent}

  controller do
    def permitted_params
      params.permit(discount_event: [:start_date, :end_date, :product_id, :original_price, :price, :title])
    end
  end

  form partial: "form"

  filter :start_date
  filter :end_date
  filter :original_price
  filter :price

  index do
    selectable_column
    column :product do |discount_event|
      discount_event.product.name
    end

    column :title
    column :start_date
    column :end_date
    column :original_price
    column :price

    default_actions
  end

  show do
    attributes_table do
      row :product do |discount_event|
        discount_event.product.name
      end
      row :title
      row :start_date
      row :end_date
      row :original_price
      row :price
      row :created_at
      row :updated_at
    end
  end
end
