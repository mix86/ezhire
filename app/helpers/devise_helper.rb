module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:div, msg) }.join
    html = "<div>#{messages}</div>"
    html.html_safe
  end

  def devise_error_messages?
    resource.errors.present?
  end
end
