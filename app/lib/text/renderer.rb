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

        sensor_markup = rendered.scan(/{\s*value\(\s*(\d+)\s*\)\s*}/).flatten
        Sensor.where(:id => sensor_markup).each do |sensor|
          s = SensorDecorator.new(sensor)
          rendered.gsub!(/({\s*value\(\s*(#{ s.id })\s*\)\s*})/, s.last_value(@opts))
        end
        
        event_markup = rendered.scan(/{\s*date\(\s*(\d+)\s*\)\s*}/).flatten
        Event.where(:id => event_markup).each do |event|
          e = EventDecorator.new(event)
          rendered.gsub!(/({\s*date\(\s*(#{ e.id })\s*\)\s*})/, e.date)
        end

        rendered
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
