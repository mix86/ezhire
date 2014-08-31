class SettingsController < ApplicationController

  helper_method :settings

  def show

  end

  def update
    user.settings.questionnaire = questionnaire
    user.settings.interview = interview
    user.save!
    render action: :show
  end

  private

  def user
    @user ||= current_user
  end

  def settings
    user.settings
  end

  def questionnaire
    permitted[:questionnaire].select(&:present?)
  end

  def interview
    permitted[:interview].select(&:present?)
  end

  def permitted
    params.permit(questionnaire: [], interview: [])
  end
end
