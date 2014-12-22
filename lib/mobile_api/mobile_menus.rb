module MobileAPI
  class MobileMenus < Grape::API

    resource :mobile_menus do
     desc "Return all of the mobile menus." 
     get do
       menus = MobileMenu.all
       error!('no mobile menu exists for now!', 404) if !menus.present?
       res = Array.new
       menus.each do |menu|
         res << { name: menu.name, priority: menu.priority, description: menu.description, image: "#{menu.image ? menu.image.url : "/"}"}
       end
       res
     end
    end
  end
end
