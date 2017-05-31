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
        
        rendered.scan(/{\s*value\(\s*(\d+)\s*\)\s*}/).each do |sensor_id|
          sensor = Sensor.find_by(id: sensor_id)
          value  = "NaN"

          unless sensor.nil?
            s = SensorDecorator.new(sensor)
            value = s.last_value(@opts)
          end
          
          rendered.gsub!(/{\s*value\(\s*(\d+)\s*\)\s*}/, value)
        end
        
        rendered.scan(/{\s*date\(\s*(\d+)\s*\)\s*}/).each do |event_id|
          event = Event.find_by(id: event_id)
          value = "NaN"

          unless event.nil?
            e = EventDecorator.new(event)
            value = e.date
          end
          
          rendered.gsub!(/{\s*date\(\s*(\d+)\s*\)\s*}/, value)
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
