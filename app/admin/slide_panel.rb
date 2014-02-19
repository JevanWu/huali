ActiveAdmin.register SlidePanel do
  menu parent: '设置', if: proc { authorized? :read, SlidePanel}

  controller do
    def permitted_params
      params.permit(slide_panel: [:name, :href, :visible, :priority, :image]) 
    end
  end

  form html: {enctype: "multipart/form-data"} do |f|
    f.inputs do
      f.input :name
      f.input :href
      f.input :priority, required: true
      f.input :image, as: :file
      f.input :visible, as: :boolean
      f.actions
    end
  end

  index do
    selectable_column
    column "ID" do |slide_panel|
      link_to slide_panel.id, admin_slide_panel_path(slide_panel)
    end
    column :name
    column :href
    column :priority
    column :image do |slide_panel|
      image_tag slide_panel.img(:thumb)
    end
    default_actions
  end


  show do
    attributes_table do
      row :name
      row :href
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
        image_tag slide_panel.image.url(:thumb)
      end

      row :medium_image do
        image_tag slide_panel.image.url(:medium)
      end
      row :image_updated_at
    end
  end
end
