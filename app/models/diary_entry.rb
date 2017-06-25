class DiaryEntry < ActiveRecord::Base
  attr_accessor :heading, :introduction, :main_part, :closing

  after_initialize do
    self.moment ||= Time.now
    self.heading ||= ''
    self.introduction ||= ''
    self.main_part ||= ''
    self.closing ||= ''
  end


  enum intention: [:real, :fake]
  LIMIT = 10
  belongs_to :report

  def live?
    created_at.nil?
  end

  def text_components
    report.active_sensor_story_components(self)
  end

  def archive!
    self.intention ||= :real
    DiaryEntry.transaction do
      if DiaryEntry.send(self.intention).count >= DiaryEntry::LIMIT
        DiaryEntry.send(self.intention).first.destroy
      end
      self.save!
    end
  end

end
