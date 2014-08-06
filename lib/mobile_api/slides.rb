module MobileAPI
  class Slides < Grape::API

    resource :slides do
     desc "Return all visible slides." 
     get do
       slides = SlidePanel.visible
       res = Array.new
       slides.each do |slide|
         slide_info = { id: slide.id, name: slide.name, priority: slide.priority, href: slide.href, image: "#{slide.image ? slide.image.url : "/"}" }
         res << slide_info
       end
       res
     end

     desc "Return a slide"
     params do
       requires :id, type: Integer, desc: "Slide id."
     end
     get ":id" do
       slide = SlidePanel.find(params[:id])
       res = { id: slide.id, name: slide.name, priority: slide.priority, href: slide.href, image: "#{slide.image ? slide.image.url : "/"}" }
     end
    end
  end
end
