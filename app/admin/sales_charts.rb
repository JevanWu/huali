# -*- coding: utf-8 -*-
ActiveAdmin.register SalesChart do
  sortable tree: false,
           protect_root: false,
           sorting_attribute: :position

  controller do
    def create
      super do |format|
        redirect_to collection_url, notice: t('active_admin.notice.created') and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to collection_url, notice: t('active_admin.notice.updated') and return if resource.valid?
      end
    end

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

