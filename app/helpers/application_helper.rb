module ApplicationHelper
  def error_class resource, key
    if resource.errors[key].present?
      :error
    else
      ''
    end
  end

  def errors resource, key
    html = resource.errors[key].map do |err|
      "<span class='error'>#{err}</span>"
    end
    raw html.join("\n")
  end
end
