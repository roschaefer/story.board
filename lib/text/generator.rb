module Text
  class Generator
    def self.generate(report, intention = :real)
      headings      = []
      introductions = []
      main_parts    = []
      closings      = []
      report.active_text_components(intention).each do |component|
        headings      << component.heading.to_s
        introductions << render(component, :introduction, intention)
        main_parts    << render(component, :main_part,    intention)
        closings      << render(component, :closing,      intention)
      end

      {
        heading:       headings.join,
        introduction:  introductions.join,
        main_part:     main_parts.join,
        closing:       closings.join
      }

    end

    def self.render(text_component, part, intention)
      template = text_component.send(part).to_s
      unless template =~ /({.*})/
        return template
      else
        rendered = template
        text_component.sensors.each do |sensor|
          s = SensorDecorator.new(sensor, intention)
          rendered.gsub!(/({\s*#{ Regexp.quote(s.name) }\s*})/, s.last_value)
        end
        return rendered
      end
    end
  end
end
