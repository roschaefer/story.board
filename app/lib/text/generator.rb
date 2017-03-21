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
      Renderer.new(text_component: text_component, opts: @opts).render(part)
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
        @components = @report.active_sensor_story_components(@opts)
        @components = @components.shuffle
        @nil_priorities, @components = @components.partition {|c| c.priority.nil? }
        @components = components.sort_by {|c| Trigger.priorities[c.priority] }
        @components = components.reverse
        @components = @components + @nil_priorities
      end
      @components
    end
  end
end
