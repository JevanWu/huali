module MobileAPI
  class Stories < Grape::API
    resource :stories do
     desc "Return all visible stories." 
     get do
       stories = Story.available
       error!('no weibo story exists for now!', 404) if !stories.present?
       res = Array.new
       stories.each do |story|
         story_info = { id: story.id, name: story.name, description: story.description, picture: "#{story.picture ? story.picture.url : "/"}", author_avatar: "#{story.author_avatar ? story.author_avatar.url : "/"}" }
         res << story_info
       end
       res
     end
    end
  end
end
