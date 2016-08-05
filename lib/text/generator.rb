module Text
  class Generator
    def initialize(report, intention = :real)
      @report = report
      @intention = intention
    end

    def generate
      headings      = []
      introductions = []
      main_parts    = []
      closings      = []
      @report.active_text_components(@intention).each do |component|
        headings      << component.heading.to_s
        introductions << render(component, :introduction)
        main_parts    << render(component, :main_part)
        closings      << render(component, :closing)
      end

      {
        heading:       headings.join(" "),
        introduction:  introductions.join(" "),
        main_part:     main_parts.join(" "),
        closing:       closings.join(" ")
      }

    end

    def render(text_component, part)
      template = text_component.send(part).to_s
      unless template =~ /({.*})/
        return template
      else
        rendered = template
        rendered = render_report(rendered)
        text_component.sensors.each do |sensor|
          s = SensorDecorator.new(sensor, @intention)
          rendered.gsub!(/({\s*#{ Regexp.quote(s.name) }\s*})/, s.last_value)
        end
        return rendered
      end
    end

    def render_report(input)
      input.gsub(/({\s*report\s*})/, @report.name)
    end
  end
end
