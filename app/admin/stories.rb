# encoding: utf-8
ActiveAdmin.register Story do
  menu parent: '设置', if: proc { authorized? :read, Story }

  controller do
    private

    def permitted_params
      params.permit story: [:name, :description, :picture, :author_avatar, :available, :origin_link, :product_link, :priority]
    end
  end

  form partial: "form"

  filter :name
  filter :description
  filter :available

  scope :available, default: true
  scope :unavailable

  config.sort_order = "priority_asc"

  sortable tree: false,
           protect_root: false,
           sorting_attribute: :priority

  index as: :sortable do
    label :picture do |story|
      %(
        #{image_tag(story.picture.url(:medium), height: '100px')}
        #{story.name}: #{story.description.truncate(50)}
      ).html_safe
    end

    actions
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

      row :product_link do
        link_to(story.product_link) unless story.product_link.blank?
      end

      row :priority

      row :available
    end
  end
end

