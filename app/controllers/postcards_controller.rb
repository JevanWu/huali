require 'securerandom'
class PostcardsController < ApplicationController
  
  def new
    if params[:order_id]
      order = Order.find params[:order_id]
      @postcard = order.build_postcard
    else
      @postcard = Postcard.new
    end
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
    @postcard = Postcard.friendly.find(params[:id])
    answer = params[:answer]
    if (!@postcard.question.nil?) && (answer != @postcard.answer)
      redirect_to postcards_question_path(@postcard)
    end
  end

  def question
    @postcard = Postcard.find(params[:id])
  end

  private
  def permitted_params
    params.require(:postcard).permit(:content, :question, :answer, :order_id, assets_attributes: [:image, :_destroy])
  end

  def generate_identifier
    SecureRandom.uuid
  end
end
