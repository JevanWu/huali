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

  show do
    attributes_table do
      row :id
      row :name
      row :province_ids do
        default_region_rule[:province_ids].map { |p_id| Province.find(p_id).name }
      end
      row :city_ids do
        default_region_rule[:city_ids].map { |c_id| City.find(c_id).name }
      end
      row :area_ids do
        default_region_rule[:area_ids].map { |a_id| Area.find(a_id).name }
      end
      row :created_at
      row :updated_at
    end
  end

  form partial: "form"

  controller do
    private

    def permitted_params
      params.permit(default_region_rule: [:name, :area_ids, :city_ids, :province_ids])
    end
  end
end
