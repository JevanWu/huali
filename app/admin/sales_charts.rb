# -*- coding: utf-8 -*-
ActiveAdmin.register SalesChart do
  sortable tree: false,
           protect_root: false,
           sorting_attribute: :position

  controller do
    def create
      @sales_chart = SalesChart.new(permitted_params[:sales_chart])
      if @sales_chart.save
        redirect_to admin_sales_charts_path
      else
        render 'new'
      end
    end
    def update
      @sales_chart = SalesChart.find(params[:id])
      if @sales_chart.update_attributes(permitted_params[:sales_chart])
        redirect_to admin_sales_charts_path
      else
        render 'new'
      end
    end

    private
    def permitted_params
      params.permit(sales_chart: [:position, :product_id])
    end
  end

  index as: :sortable do
    label :product
    actions
  end
end

