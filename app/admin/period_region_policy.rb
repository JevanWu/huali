ActiveAdmin.register PeriodRegionPolicy do
  menu parent: "设置", if: proc { authorized? :manage, PeriodRegionPolicy }

  controller do
    def full_period_region_policy_fields
      [
        :start_date,
        :end_date,
        :local_region_rule_attributes => [:province_ids, :city_ids, :area_ids, :_destroy]
      ]
    end

    def permitted_params
      params.permit(period_region_policy: full_period_region_policy_fields)
    end
  end

  filter :start_date
  filter :end_date

  index do
    selectable_column
    column :start_date
    column :end_date

    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :start_date
      row :end_date
      row :local_region_rule
    end
  end
end
