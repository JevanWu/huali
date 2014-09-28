# -*- coding: utf-8 -*-
ActiveAdmin.register SalesChart do
  sortable tree: false,
           protect_root: false,
           sorting_attribute: :position

  collection_action :create, :method => :post do
    redirect_to({action: :index}, {notice: "created_done"})
  end
  collection_action :update, :method => :put do
    redirect_to({action: :index}, {notice: "updated_done"})
  end

  controller do
    private
    def permitted_params
      params.permit(sales_chart: [:position, :product_id])
    end
  end

  form partial: "form"

  index as: :sortable do
    label :product
    actions
  end
end

