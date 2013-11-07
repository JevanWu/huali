class SurveysController < ApplicationController
  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)
    @survey.user = current_user if current_user

    if @survey.save

      flash[:notice] = t('controllers.survey.survey_success')
      redirect_to controller: :products, action: :trait, tags: @survey.to_trait_tags
    else
      render 'new'
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:gender, :receiver_gender, :receiver_age, :relationship, :gift_purpose)
  end
end
