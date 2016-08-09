module Text
  class Generator
    def initialize(report, intention = :real)
      @report = report
      @intention = intention
    end

    def generate
      introductions = []
      main_parts    = []
      closings      = []
      @report.active_text_components(@intention).each do |component|
        introductions << render(component, :introduction)
        main_parts    << render(component, :main_part)
        closings      << render(component, :closing)
      end

      {
        heading:       choose_heading,
        introduction:  introductions.join(" "),
        main_part:     main_parts.join(" "),
        closing:       closings.join(" ")
      }

    end

    def choose_heading
      components = @report.active_text_components(@intention)
      return '' if components.empty?
      groups = components.group_by {|c| TextComponent.priorities[c.priority]}
      p_values = TextComponent.priorities.values.sort.reverse
      p_values += [nil] # no priority is always lowest priority
      p_values.each do |p|
        return groups[p].sample.heading if groups[p].present?
      end
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
      result = input.gsub(/({\s*report\s*})/, @report.name)
      @report.variables.each do |v|
        result = input.gsub(/({\s*#{Regexp.quote(v.key)}\s*})/, v.value)
      end
      result
    end
  end
end
