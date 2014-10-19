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

  def now
    Time.now
  end

  def d dt
    dt.strftime '%d.%m.%Y'
  end

  def t dt
    dt.strftime '%H:%M'
  end
end
