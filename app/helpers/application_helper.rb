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

  def field_row label, &block
    content = capture(&block)
    html = <<-HTML
    <div class='row collapse prefix-radius'>
      <div class='small-2 columns'>
        <span class='prefix'><b>#{label}</b></span>
      </div>
      <div class='small-10 columns'>
        #{content}
      </div>
    </div>
    HTML
    raw html
  end

  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new Redcarpet::Render::HTML,
                                          fenced_code_blocks: true,
                                          space_after_headers: true,
                                          no_intra_emphasis: true,
                                          autolink: true,
                                          strikethrough: true,
                                          highlight: true,
                                          quote: true
    raw @markdown.render(content)
  end
end
