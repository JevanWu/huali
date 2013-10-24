class StoriesController < ApplicationController
  def index
    @stories = Story.available.page(params[:page])
    @result = @stories.map do |story|
      { description: story.description, src: story.picture.url(:medium), width: 200, height: 260 }
    end

    render :json => @result.to_json, :callback => params[:callback]
  end
end
