# encoding: utf-8
ActiveAdmin.register Story do
  menu parent: '设置', if: proc { authorized? :read, Story }

  controller do
    private

    def permitted_params
      params.permit story: [:name, :description, :picture, :author_avatar, :available, :origin_link]
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
      row :picture do
        image_tag story.picture.url(:medium)
      end

      row :author_avatar do
        image_tag story.author_avatar.url(:small)
      end

      row :origin_link do
        link_to(story.origin_link) unless story.origin_link.blank?
      end

      row :available
    end
  end
end

