# encoding: utf-8
ActiveAdmin.register Story do
  menu parent: '设置', if: proc { authorized? :read, Story }

  controller do
    private

    def permitted_params
      params.permit story: [:name, :description, :picture, :available]
    end
  end

  form partial: "form"

  index do
    selectable_column
    column :name
    column :description
    column :available

    default_actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :available
      row :picture do
        image_tag story.picture.url(:medium)
      end
    end
  end
end

