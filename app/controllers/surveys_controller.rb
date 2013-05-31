class SurveysController < ApplicationController
  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(params[:survey])
    @survey.user = current_user if current_user

    if @survey.save
      flash[:notice] = t('controllers.survey.survey_success')
    else
      render 'new'
    end
  end
end
