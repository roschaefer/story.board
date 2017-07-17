module Text
  class Generator
    BREAK_AFTER = 500 # characters

    def initialize(diary_entry)
      @diary_entry = diary_entry
    end

    def attributes_for_diary_entry
      {
        heading:       choose_heading,
        introduction:  important_introductions,
        main_part:     html_main_part,
        closing:       combine_closings
      }
    end

    def generate_diary_entry
      @diary_entry.assign_attributes attributes_for_diary_entry
      @diary_entry
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
            partial: 'diary_entries/question_answers',
            locals: {
              question_answers: current_component.question_answers,
              diary_entry: @diary_entry
            }
          )

        end


        result += ApplicationController.render(
          partial: 'diary_entries/split_part',
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
      Renderer.new(text_component: text_component, diary_entry: @diary_entry).render(part)
    end

    def important_introductions
      introductions = components.first(3).collect do |component|
        render(component, :introduction)
      end
      introductions = introductions.select{|i| i.present?}
      ApplicationController.render(
        partial: 'diary_entries/introduction',
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
      @components ||= Text::Sorter.sort(@diary_entry.text_components)
    end
  end
end
