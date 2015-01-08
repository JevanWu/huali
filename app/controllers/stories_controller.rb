class StoriesController < ApplicationController
  def index
    cache_key = "stories/all-#{Story.available.count}-#{Story.available.maximum(:updated_at).try(:utc).try(:to_s, :number)}/page/#{params[:page]}"
    raise ArgumentError, "Wrong page number" if params[:page].to_i * 8 > 800 # Only display 100 pages of stories
    stories_json = Rails.cache.fetch(cache_key) do
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
      end.to_json
    end

    render :json => stories_json, :callback => params[:callback]
  end
end
