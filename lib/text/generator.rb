module Text
  class Generator
    BREAK_AFTER = 500 # characters

    def initialize(report:, opts: {})
      @report = report
      @opts = opts
    end

    def generate
      {
        heading:       choose_heading,
        introduction:  combine_introductions,
        main_part:     combine_main_parts,
        closing:       combine_closings
      }
    end

    def choose_heading
      return '' if components.empty?
      components.first.heading
    end

    private

    def render(text_component, part)
      template = text_component.send(part).to_s
      unless template =~ /({.*})/
        return template
      else
        rendered = template
        rendered = render_report(rendered)
        text_component.sensors.each do |sensor|
          s = SensorDecorator.new(sensor)
          rendered.gsub!(/({\s*#{ Regexp.quote("value(#{s.id})") }\s*})/, s.last_value(@opts))
        end
        text_component.events.each do |event|
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

    def combine_introductions
      introductions = components.collect do |component|
        render(component, :introduction)
      end
      introductions.join(' ')
    end

    def combine_closings
      closings = components.collect do |component|
        render(component, :closing)
      end
      closings.join(' ')
    end

    def combine_main_parts
      character_count = 0
      result = ""
      components.each_with_index do |component, i|
        part = render(component, :main_part)
        result += ' ' unless i == 0
        result += part
        character_count += part.length
        if character_count >= BREAK_AFTER
          next_component = components[i+1]
          if next_component
            # HACK: this generator knows the output medium
            result += "</p>"
            result += "<h4 class=\"sub-heading\">#{next_component.heading}</h4>"
            result += "<p>"
            character_count = 0 # reset character count
          end
        end
      end
      result
    end

    def components
      if @components.nil?
        @components = @report.active_text_components(@opts)
        #@components = components.shuffle
        #@components = components.sort_by {|c| TextComponent.priorities[c.priority] }
        #@components = components.reverse
      end
      @components
    end
  end
end
