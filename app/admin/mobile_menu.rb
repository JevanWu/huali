ActiveAdmin.register MobileMenu do
  menu parent: '设置', if: proc { authorized? :read, MobileMenu }

  sortable tree: false,
           protect_root: false,
           sorting_attribute: :priority
  
  controller do
    def permitted_params
      params.permit mobile_menu: [:name, :href, :description, :priority, :image]
    end
  end
  
  index as: :sortable do
    label :image do |phrase|
      image_tag phrase.image.url(:thumb)
    end
    actions
  end

  form do |f|
    f.inputs "Main Info" do 
      f.input :name
      f.input :priority
      f.input :description
      f.input :image
    end
    f.actions
  end
end
