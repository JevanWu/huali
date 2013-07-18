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
end
