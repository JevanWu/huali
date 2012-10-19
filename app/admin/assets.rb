ActiveAdmin.register Asset do

  filter :viewable_type, :as => :select, :collection =>  Asset.pluck(:viewable_type).uniq
  filter :image_file_name
  filter :image_updated_at

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :image, :as => :file
      f.input :viewable_type, :label => "BelongsTo"
    end
    f.buttons
  end

  show do |asset|
    attributes_table do
      row :viewable_type

      row :file_name do
        asset.image_file_name
      end

      row :file_size do
        number_to_human_size(asset.image_file_size)
      end

      row :content_type do
        asset.image_content_type
      end

      row :image_updated_at

      row :thumbnails do
        image_tag asset.image.url(:thumb)
      end

      row :medium_image do
        image_tag asset.image.url(:medium)
      end

      row :full_image do
        image_tag asset.image.url
      end
    end
  end

end
