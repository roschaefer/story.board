class DiaryEntry < ActiveRecord::Base
  attr_accessor :heading, :introduction, :main_part, :closing

  after_initialize do
    self.moment ||= Time.now
    self.heading ||= ''
    self.introduction ||= ''
    self.main_part ||= ''
    self.closing ||= ''
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

  def rendered_text_components
    text_components.collect { |component| TextComponentDecorator.new(component, self) }
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

  def compose
    generator = ::Text::Generator.new(self)
    generator.generate_diary_entry
  end
end
