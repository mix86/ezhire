class ProjectInterviewsController < ApplicationController
  include Projectable

  def show
  end

  def update
    project.interview = interview
    project.save!
    render action: :show
  end

  private

  def interview
    permitted[:interview].select(&:present?)
  end

  def permitted
    params.require(:project).permit(interview: [])
  end
end
