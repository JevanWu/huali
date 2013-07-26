# encoding: utf-8
ActiveAdmin.register Survey do
  menu parent: '设置', if: proc { authorized? :read, Survey }

  batch_action :destroy, false

  controller do
    private

    def permitted_params
      params.permit survey: [:user_id, :gender, :receiver_gender, :gift_purpose]
    end
  end

  index do
    selectable_column
    column :gender
    column :gift_purpose
    column :receiver_gender
    column :user

    default_actions
  end

  show do
    attributes_table do
      row :gender
      row :gift_purpose
      row :receiver_gender
      row :user
    end
  end
end
