class SettingsTemplatesController < SettingsController

  helper_method :template

  def index
  end

  def show
  end

  def create
    settings.templates << Template.new(permitted)
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

  private

  def template
    settings.templates.find params[:id]
  end

  def permitted
    params.require(:template).permit(:name, :private, :body)
  end

  def index_url
    settings_settings_templates_url
  end
end
