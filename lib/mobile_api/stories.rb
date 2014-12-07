module MobileAPI
  class Stories < Grape::API
    resource :stories do
    desc "Return all visible stories." 
    params do
      optional :per_page, type: Integer, desc: "The amount of stories presented on each page"
      optional :page, type: Integer, desc: "The number of page queried"
    end
     get do
       if params[:per_page]&&params[:page]
         stories = Story.available.limit(params[:per_page]).offset(params[:per_page]*(params[:page] - 1))
       else
         stories = Story.available
       end
       error!('no weibo story exists for now!', 404) if !stories.present?
       res = Array.new
       stories.each do |story|
         story_info = { id: story.id, name: story.name, description: story.description, picture: "#{story.picture ? story.picture.url : "/"}", author_avatar: "#{story.author_avatar ? story.author_avatar.url : "/"}", origin_link: story.origin_link, product_id: story.product.id }
         res << story_info
       end
       res
     end
    end
  end
end
