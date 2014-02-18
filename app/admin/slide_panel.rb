ActiveAdmin.register SlidePanel do
  controller do
    def permitted_params
      params.permit(slide_panel: [:name, :href, :visible, :priority, :assets_attributes => [:id, :image]])
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :href
      f.input :priority, required: true
      f.has_many :assets do |asset|
        asset.input :image, as: :file
      end
      f.input :visible, as: :boolean
      f.actions
    end
  end
end
