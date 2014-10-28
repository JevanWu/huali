module MobileAPI
  class GuideViews < Grape::API
    resource :guide_views do
     desc "Return all available guide views." 
     get do
       guide_views = GuideView.where(available: true)
       error!('no guide views exists for now!', 404) if !guide_views.present?
       res = Array.new
       guide_views.each do |guide_view|
         guide_view_info = { id: guide_view.id, description: guide_view.description, image: "#{guide_view.image ? guide_view.image.url : "/"}", priority: guide_view.priority }
         res << guide_view_info
       end
       res
     end
    end
  end
end
