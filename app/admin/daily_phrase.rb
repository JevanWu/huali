ActiveAdmin.register DailyPhrase do

  controller do
    def permitted_params
      params.permit daily_phrase: [:title, :phrase, :image]
    end
  end

  index do
    column :title
    column :phrase
    column :image do |phrase|
      image_tag phrase.image.url(:thumb)
    end
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs "Main Info" do 
      f.input :title
      f.input :phrase
      f.input :image
    end
    f.actions
  end
end
