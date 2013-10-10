class SurveysController < ApplicationController
  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)
    @survey.user = current_user if current_user

    if @survey.save
      #require 'pry'; require 'pry-remote'; binding.remote_pry;
      @products = Product.published
        .tagged_with(survey_params[:receiver_gender], any: true)
        .tagged_with(survey_params[:gift_purpose], any: true)

      flash[:notice] = t('controllers.survey.survey_success')
    else
      render 'new'
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:gender, :gift_purpose, :receiver_gender)
  end
end
