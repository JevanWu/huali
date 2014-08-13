module MobileAPI
  class Slides < Grape::API

    resource :slides do
     desc "Return all visible slides." 
     get do
       slides = SlidePanel.visible
       error!('no visible slides exists for now!', 404) if slides.nil?
       res = Array.new
       slides.each do |slide|
         slide_info = { id: slide.id, name: slide.name, href: slide.href, priority: slide.priority, image: "#{slide.image ? slide.image.url : "/"}" }
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
       error!('There is no such slide!', 404) if slide.nil?
       res = { id: slide.id, name: slide.name, href: slide.href, priority: slide.priority, image: "#{slide.image ? slide.image.url : "/"}" }
     end
    end
  end
end
