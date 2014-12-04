ActiveAdmin.register Menu do
  menu parent: '设置', if: proc { authorized? :read, SlidePanel}

  sortable tree: true,
           max_levels: 2, # infinite indent levels
           protect_root: false, # allow root items to be dragged
           sorting_attribute: :priority,
           parent_method: :parent,
           children_method: :children,
           roots_method: :roots,
           collapsible: true

  controller do
    def permitted_params
      params.permit(menu: [:name, :link, :availabel, :collection_id])
    end
  end

  filter :name

  scope :available, default: true
  scope :unavailable

  form partial: "form"

  index as: :sortable do
    label :name
    actions
  end

  show do
    attributes_table do
      row :name
      row :link
      row :available
      row :created_at
      row :updated_at
    end
  end
end
