# encoding: utf-8
ActiveAdmin.register DefaultDateRule do
  menu parent: "设置", if: proc { authorized? :manage, DefaultDateRule }

  config.filters = false

  index do
    column :id
    column :name
    column :start_date
    column :end_date
    column :created_at
    column :updated_at

    default_actions
  end

  form partial: "form"

  controller do
    private

    def permitted_params
      params.permit(default_date_rule: [:name, :period_length, :start_date, :excluded_dates, { excluded_weekdays: [] }, :included_dates])
    end
  end
end
