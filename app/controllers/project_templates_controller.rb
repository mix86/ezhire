class ProjectTemplatesController < ApplicationController
  include Projectable

  helper_method :template

  def index
  end

  def show
  end

  def create
    create!
    redirect_to :index
  end

  def update
    update!
    redirect_to :index
  end

  def destroy
    destroy!
    redirect_to :index
  end

  private

  def template
    project.templates.find params[:id]
  end

  def create!
    project.templates << Template.new(permitted)
  end

  def update!
    template.update permitted
  end

  def destroy!
    template.delete
  end

  def permitted
    params.require(:template).permit(:name, :private, :body)
  end

  def index_url
    project_project_templates_url
  end
end
