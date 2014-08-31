module Projectable
  extend ActiveSupport::Concern

  included do
    layout 'dashboard'

    helper_method :project, :projects
  end

  def projects
    Project.of(current_user)
  end

  def project
    @project ||= projects.find(params[:project_id])
  end
end
