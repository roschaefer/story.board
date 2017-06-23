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
        introduction:  important_introductions,
        main_part:     html_main_part,
        closing:       combine_closings
      }
    end

    def generate_record
      Record.new(generate.merge(report: @report, intention: @opts[:intention]))
    end

    def choose_heading
      return '' if components.empty?
      render(components.first, :heading)
    end

    def html_main_part
      result = ""
      part = ''
      stack = components.clone
      until stack.empty? do
        until part.length >= BREAK_AFTER || stack.empty? do
          current_component = stack.shift
          if result.present? # no subheading at the very beginning
            subheading ||= current_component.heading
          end
          part += ' ' if part.present?
          part += render(current_component, :main_part)

          part += ApplicationController.render(
            partial: 'records/question_answers',
            locals: {
              question_answers: current_component.question_answers,
              opts: @opts
            }
          )

        end


        result += ApplicationController.render(
          partial: 'records/split_part',
          locals: { subheading: subheading, part: part }
        )

        # reset
        part = ''
        subheading = nil
      end

      result
    end

    private

    def render(text_component, part)
      Renderer.new(text_component: text_component, opts: @opts).render(part)
    end

    def important_introductions
      introductions = components.first(3).collect do |component|
        render(component, :introduction)
      end
      introductions = introductions.select{|i| i.present?}
      ApplicationController.render(
        partial: 'records/introduction',
        locals: {
        items: introductions,
        }
      )
    end

    def combine_closings
      closings = components.collect do |component|
        render(component, :closing)
      end
      closings.join(' ')
    end

    def components
      @components ||= Text::Sorter.sort(@report.active_sensor_story_components(@opts), @opts)
    end
  end
end
