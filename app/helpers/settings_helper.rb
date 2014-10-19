module SettingsHelper
  def active? tab
    :active if params.has_key? tab
  end
end
