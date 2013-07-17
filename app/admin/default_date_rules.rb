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
    before_action :setup_rule_params, only: [:create, :update]

    private

    def permitted_params
      params.permit(default_date_rule: [:name, :period_length, :start_date, excluded_dates: [], excluded_weekdays: [], included_dates: []])
    end

    def setup_rule_params
      params[:default_date_rule][:included_dates] = params[:default_date_rule][:included_dates].split(',')
      params[:default_date_rule][:excluded_dates] = params[:default_date_rule][:excluded_dates].split(',')
    end
  end
end
