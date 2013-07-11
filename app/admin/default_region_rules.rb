# encoding: utf-8
ActiveAdmin.register DefaultRegionRule do
  menu parent: "设置", if: proc { authorized? :manage, DefaultRegionRule }

  config.filters = false

  index do
    column :id
    column :name
    column :created_at
    column :updated_at

    default_actions
  end

  form partial: "form"

  controller do
    before_action :setup_rule_params, only: [:create, :update]

    private

    def permitted_params
      params.require(:default_region_rule).permit!
    end

    def setup_rule_params
      params[:default_region_rule][:province_ids] = params[:default_region_rule][:province_ids].split(',')
      params[:default_region_rule][:city_ids] = params[:default_region_rule][:city_ids].split(',')
      params[:default_region_rule][:area_ids] = params[:default_region_rule][:area_ids].split(',')
    end
  end
end
