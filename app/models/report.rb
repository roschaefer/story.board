class Report < ActiveRecord::Base
  DATE_FORMAT = '%-d.%-m.%Y'
  DATE_TIME_FORMAT = "#{DATE_FORMAT}, %H:%M Uhr"

  has_many :triggers
  has_many :text_components
  has_many :sensors
  has_many :diary_entries
  has_many :variables, dependent: :destroy
  accepts_nested_attributes_for :variables

  def self.current
    Report.first
  end

  def active_chatbot_components(diary_entry)
    active_components(diary_entry).select {|c| c.channels.include?(Channel.chatbot) }
  end

  def active_sensor_story_components(diary_entry)
    active_components(diary_entry).select {|c| c.channels.include?(Channel.sensorstory) }
  end

  def end_date
    if start_date && duration
      start_date + duration.days
    end
  end

  private

  def active_components(diary_entry)
    result = text_components.includes(:channels)
    text_components.select {|c| c.active?(diary_entry) && c.published? }
  end
end
