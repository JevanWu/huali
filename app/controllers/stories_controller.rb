class StoriesController < ApplicationController
  def index
    @stories = Story.available.order('priority').page(params[:page]).per(8)
    @result = @stories.map do |story|
      {
        description: story.description,
        picture_url: story.picture.url(:medium),
        author_avatar_url: story.author_avatar.url(:small),
        width: 200,
        height: 260,
        origin_link: story.origin_link
      }
    end

    render :json => @result.to_json, :callback => params[:callback]
  end
end
