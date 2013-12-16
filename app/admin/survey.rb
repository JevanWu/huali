# encoding: utf-8
ActiveAdmin.register Survey do
  menu parent: '设置', if: proc { authorized? :read, Survey }

  batch_action :destroy, false

  controller do
    private

    def permitted_params
      params.permit survey: [:user_id, :gender, :receiver_gender, :receiver_age, :relationship, :gift_purpose]
    end
  end

  index do
    selectable_column
    column :gender
    column :receiver_gender
    column :receiver_age
    column :relationship
    column :gift_purpose
    column :user

    default_actions
  end

  show do
    attributes_table do
      row :gender
      row :receiver_gender
      row :receiver_age
      row :relationship
      row :gift_purpose
      row :user
    end
  end
end
