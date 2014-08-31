class ProjectQuestionnairesController < ApplicationController
  include Projectable

  def show
  end

  def update
    update_questionnaire!
    render action: :show
  end

  private

  def update_questionnaire!
    project.questionnaire = []
    permitted[:questionnaire].each do |item|
      project.questionnaire <<  Question.new(item)
    end
    project.save!
  end

  def permitted
    params.require(:project).permit(questionnaire: [:question, :answer])
  end
end
