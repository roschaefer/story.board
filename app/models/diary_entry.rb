class DiaryEntry < ActiveRecord::Base
  transient_attributes = [:heading, :introduction, :main_part, :closing]
  attr_writer *transient_attributes

  transient_attributes.each do |attribute|
    define_method attribute do
      instance_variable_get("@#{attribute}") || ''
    end
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
end
