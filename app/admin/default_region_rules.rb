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
    private

    def permitted_params
      params.permit(default_region_rule: [:name, area_ids: [], city_ids: [], province_ids: []])
    end
  end
end
