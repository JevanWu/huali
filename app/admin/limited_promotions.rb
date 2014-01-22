# encoding: utf-8
ActiveAdmin.register LimitedPromotion do
  menu parent: '设置', if: proc { authorized? :read, LimitedPromotion }

  controller do
    private

    def permitted_params
      params.permit limited_promotion: [:name, :start_at, :end_at, :adjustment, :product_id, :available_count, :expired]
    end
  end

  form partial: "form"

  filter :name
  filter :start_at
  filter :end_at

  index do
    selectable_column
    column :name
    column :start_at
    column :end_at
    column :adjustment
    column :available_count
    column :product do |limited_promotion|
      link_to(limited_promotion.product, admin_product_path(limited_promotion.product))
    end
    column :expired do |limited_promotion|
      limited_promotion.expired?
    end

    default_actions
  end

  show do
    attributes_table do
      row :name
      row :start_at
      row :end_at
      row :adjustment
      row :product do
        limited_promotion.product.name
      end

      row :available_count
      row :used_count
      row :expired do
        limited_promotion.expired?
      end
    end
  end
end

