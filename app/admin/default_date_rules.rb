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
end
