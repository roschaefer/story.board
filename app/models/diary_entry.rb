class DiaryEntry < ActiveRecord::Base
  BREAK_AFTER = 500 # characters

  after_initialize do
    self.moment ||= Time.now
  end

  enum release: [:final, :debug]
  LIMIT = 30000
  belongs_to :report

  def live?
    created_at.nil?
  end

  def text_components
    report.active_sensor_story_components(self)
  end

  def sorted_components
    Text::Sorter.sort(text_components)
  end

  def rendered_text_components
    sorted_components.collect { |component| TextComponentDecorator.new(component, self) }
  end

  def archive!
    self.release ||= :final
    DiaryEntry.transaction do
      if DiaryEntry.send(self.release).count >= DiaryEntry::LIMIT
        DiaryEntry.send(self.release).first.destroy
      end
      self.save!
    end
  end


  def heading 
    return '' if sorted_components.empty?
    render(sorted_components.first, :heading)
  end

  def introduction
    introductions = sorted_components.first(3).collect do |component|
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


  def main_part
    result = ""
    part = ''
    stack = sorted_components.clone
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
            diary_entry: self
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

  def closing
    closings = sorted_components.collect do |component|
      render(component, :closing)
    end
    closings.join(' ')
  end

  private

  def render(text_component, part)
    ::Text::Renderer.new(text_component: text_component, diary_entry: self).render(part)
  end
end
