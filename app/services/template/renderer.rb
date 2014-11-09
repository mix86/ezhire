class Template
  class Renderer
    VARS = [:person_name, :vacancy_name, :vacancy_note]

    def initialize template, context
      @template = template
      @context = context
    end

    def call
      render_body
    end

    private

    def render_body
      VARS.each do |var|
        re = Regexp.new "%#{var}%"
        body.gsub!(re) { |m| self.send var }
      end
      body
    end

    def person_name
      @context[:person].try(:name)
    end

    def vacancy_name
      @context[:project].try(:name)
    end

    def vacancy_note
      @context[:project].try(:note)
    end

    def body
      @body ||= @template.body.clone
    end
  end
end
