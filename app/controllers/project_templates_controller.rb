class ProjectTemplatesController < ApplicationController
  include Projectable

  helper_method :template

  def index
  end

  def show
  end

  def create
    project.templates << Template.new(permitted)
    redirect_to :index
  end

  def update
    template.update permitted
    redirect_to :index
  end

  def destroy
    template.delete
    redirect_to :index
  end

  def preview
  end

  private

  def template
    project.templates.find template_id
  end

  def template_id
    params[:id] || params[:project_template_id]
  end

  def permitted
    params.require(:template).permit(:name, :private, :body)
  end

  def index_url
    project_project_templates_url
  end
end
