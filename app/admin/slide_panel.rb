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
end
