ActiveAdmin.register SlidePanel do
  menu parent: '设置', if: proc { authorized? :read, SlidePanel}

  sortable tree: false,
           protect_root: false,
           sorting_attribute: :priority

  controller do
    def permitted_params
      params.permit(slide_panel: [:name, :href, :visible, :priority, :image])
    end
  end

  scope :visible, default: true
  scope :invisible

  form partial: "form"

  index as: :sortable do
    label "ID" do |slide_panel|
      link_to slide_panel.id, admin_slide_panel_path(slide_panel)
    end
    label :name
    label :href
    label :priority
    label :image do |slide_panel|
      image_tag slide_panel.img(:thumb)
    end
    actions
  end


  show do
    attributes_table do
      row :name
      row :href
      row :title
      row :description
      row :priority
      row :created_at
      row :updated_at
      row :file_name do
        slide_panel.image_file_name
      end
      row :file_size do
        number_to_human_size(slide_panel.image_file_size)
      end
      row :thumbnails do
        image_tag slide_panel.img(:thumb)
      end

      row :medium_image do
        image_tag slide_panel.img(:medium)
      end
      row :image_updated_at
    end
  end
end
