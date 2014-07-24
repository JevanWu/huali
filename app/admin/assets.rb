# encoding: utf-8
ActiveAdmin.register Asset do
  menu parent: '产品', if: proc { authorized? :read, Asset }

  controller do
    def permitted_params
      params.permit asset: [:image, :viewable_type]
    end
  end

  filter :viewable_type, as: :select, collection:  proc { Asset.pluck(:viewable_type).uniq }
  filter :image_file_name
  filter :image_updated_at

  form html: { enctype: "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :image, as: :file
      f.input :viewable_type, label: "BelongsTo"
    end
    f.actions
  end

  index do
    selectable_column
    column "Image" do |asset|
      image_tag asset.image.url(:thumb)
    end

    column "Viewable Type" do |asset|
      asset.viewable_type
    end

    column "File_size" do |asset|
      asset.image_file_size
    end

    column "Image_updated_at" do |asset|
      asset.image_updated_at
    end

    default_actions
  end

  show do
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
