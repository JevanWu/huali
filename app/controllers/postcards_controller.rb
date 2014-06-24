require 'securerandom'
class PostcardsController < ApplicationController
  
  def new
    @postcard = Postcard.new
    @asset = @postcard.assets.build
  end

  def create
    loop do
      new_identifier = generate_identifier
      if @postcard = Postcard.create(permitted_params.merge({identifier: new_identifier}))
        next if @postcard.errors.messages.to_s.scan(/identifier/).present?
        redirect_to postcard_path(@postcard)
        break
      else
        render 'new'
        break
      end
    end
  end

  def show
    @postcard = Postcard.find(params[:id])
  end

  private
  def permitted_params
    params.require(:postcard).permit(:content, :question, :answer, assets_attributes: [:image, :_destroy])
  end

  def generate_identifier
    SecureRandom.uuid
  end
end
