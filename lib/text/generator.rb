module Text
  class Generator
    def self.generate(report, source = :real)
      headings      = []
      introductions = []
      main_parts    = []
      closings      = []
      report.active_text_components.each do |component|
        headings      << component.heading.to_s
        introductions << render(component, :introduction)
        main_parts    << render(component, :main_part)
        closings      << render(component, :closing)
      end

      {
        heading:       headings.join,
        introduction:  introductions.join,
        main_part:     main_parts.join,
        closing:       closings.join
      }

    end

    def self.render(text_component, part)
      template = text_component.send(part).to_s
      unless template =~ /({.*})/
        return template
      else
        rendered = template
        text_component.sensors.each do |sensor|
          s = SensorDecorator.new(sensor)
          rendered.gsub!(/({\s*#{ Regexp.quote(s.name) }\s*})/, s.last_value)
        end
        return rendered
      end
    end
  end
end
