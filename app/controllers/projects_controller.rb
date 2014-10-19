class ProjectsController < ApplicationController
  include Projectable

  layout :layout

  def index
  end

  def create
    redirect_to project_path(create_project!)
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
                                        questionnaire: default_questionnaire,
                                        templates: default_templates
  end

  def default_questionnaire
    settings.questionnaire.map { |q| Question.new question: q }
  end

  def default_interview
    settings.interview
  end

  def default_templates
    settings.templates
  end

  def redirect
    redirect_to projects_path
  end

  def project_params
    params.permit(:name, :note)
  end

  def layout
    case params[:action]
    when 'index'
      'application'
    else
      'project'
    end
  end
end
