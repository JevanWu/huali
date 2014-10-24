ActiveAdmin.register GuideView do
  menu parent: '设置', if: proc { authorized? :read, GuideView}

  sortable tree: false,
           protect_root: false,
           sorting_attribute: :priority

  controller do
    def permitted_params
      params.permit(guide_view: [:description, :available, :priority, :image])
    end
  end

  form do |f|
    f.inputs "Main" do
      f.input :description
      f.input :priority
      f.input :image, as: :file
      f.input :available, as: :boolean
      f.actions
    end
  end

  index as: :sortable do
    label :image do |guide_view|
      image_tag guide_view.image.url(:thumb)
    end
    actions
  end


  show do
    attributes_table do
      row :description
      row :priority
      row :created_at
      row :updated_at
      row :available
      row :file_name do
        guide_view.image_file_name
      end
      row :file_size do
        number_to_human_size(guide_view.image_file_size)
      end
      row :thumbnails do
        image_tag guide_view.image.url(:thumb)
      end

      row :medium_image do
        image_tag guide_view.image.url(:medium)
      end
      row :image_updated_at
    end
  end
end
