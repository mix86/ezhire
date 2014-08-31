module ProjectsHelper
  def active_tab
    # raise RuntimeError
    # controller.params[:action]
    controller.controller_name.to_sym
  end
end
