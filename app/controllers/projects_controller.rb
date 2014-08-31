class ProjectsController < ApplicationController
  include Projectable

  def index
  end

  def create
    create_project!
    redirect
  end

  def show
  end

  def destroy
    project.destroy!
    redirect
  end

  def interview
  end

  private

  def project
    projects.find(params[:id])
  end

  def create_project!
    Project.create project_params.merge owner: current_user,
                                        interview: default_interview,
                                        questionnaire: default_questionnaire
  end

  def default_questionnaire
    settings.questionnaire.map { |q| Question.new question: q }
  end

  def default_interview
    settings.interview
  end

  def redirect
    redirect_to '/'
  end

  def project_params
    params.permit(:name, :note)
  end
end
