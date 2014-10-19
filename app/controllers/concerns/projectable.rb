module Projectable
  extend ActiveSupport::Concern

  included do
    layout 'project'

    helper_method :project, :projects

    helper ProjectsHelper
  end

  def projects
    Project.of(current_user)
  end

  def project
    @project ||= projects.find(params[:project_id])
  end
end
