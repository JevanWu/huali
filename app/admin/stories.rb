# encoding: utf-8
ActiveAdmin.register Story do
  menu parent: '设置', if: proc { authorized? :read, Story }

  controller do
    private

    def permitted_params
      params.permit story: [:name, :description, :picture, :author_avatar, :available]
    end
  end

  form partial: "form"

  filter :name
  filter :description
  filter :available

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

      row :author_avatar do
        image_tag story.author_avatar.url(:small)
      end
    end
  end
end

