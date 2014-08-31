class DashboardsController < ApplicationController
  helper_method :projects

  layout 'dashboard'


  def index
  end

  private

  def projects
    Project.of(current_user)
  end
end
