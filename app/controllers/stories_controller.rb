class StoriesController < ApplicationController
  respond_to :json

  def index
    @stories = Story.available.page(params[:page])
    @result = @stories.map do |story|
      { description: story.description, src: story.picture.url(:medium) }
    end

    respond_with(@result)
  end
end
