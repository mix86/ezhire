module ProjectsHelper
  def active_tab
    controller.controller_name.to_sym
  end
end
