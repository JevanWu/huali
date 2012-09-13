ActiveAdmin.register Asset do

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :image, :as => :file
      f.input :viewable_id
      f.input :viewable_type
    end
    f.buttons
  end

end
