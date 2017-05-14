module Text
  class Renderer
    def initialize(text_component:, opts: {})
      @text_component = text_component
      @report = @text_component.report
      @opts = opts
    end

    def render(part)
      template = @text_component.send(part).to_s
      render_string(template)
    end

    def render_string(template)
      unless template =~ /({.*})/
        return template
      else
        rendered = template
        rendered = render_report(rendered)
        @text_component.sensors.each do |sensor|
          s = SensorDecorator.new(sensor)
          rendered.gsub!(/({\s*#{ Regexp.quote("value(#{s.id})") }\s*})/, s.last_value(@opts))
        end
        @text_component.events.each do |event|
          e = EventDecorator.new(event)
          rendered.gsub!(/({\s*#{ Regexp.quote("date(#{e.id})") }\s*})/, e.date)
        end
        return rendered
      end
    end

    def render_report(input)
      result = input.gsub(/({\s*report\s*})/, @report.name)
      @report.variables.each do |v|
        result = result.gsub(/({\s*#{Regexp.quote(v.key)}\s*})/, v.value)
      end
      result
    end
  end
end
