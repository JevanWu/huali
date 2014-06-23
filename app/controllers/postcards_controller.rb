class PostcardsController < ApplicationController
  
  def new
    @postcard = Postcard.new
  end

  def create
    if @postcard = Postcard.create(permitted_params)
      redirect_to postcard_path(@postcard)
    else
      render 'new'
    end
  end

  def show
    @postcard = Postcard.find(params[:id])
  end

  private
  def permitted_params
    params.require(:postcard).permit(:content, :question)
  end
end
