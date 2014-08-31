class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def settings
    if current_user.settings.nil?
      current_user.settings = Settings.new
      current_user.save!
    end
    current_user.settings
  end
end
