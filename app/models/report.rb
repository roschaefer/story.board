class Report < ActiveRecord::Base
  TIME_ZONE   = 'Europe/Berlin'
  DATE_FORMAT = '%-d.%-m.%Y'
  DATE_TIME_FORMAT = "#{DATE_FORMAT}, %H:%M Uhr"

  has_many :triggers
  has_many :text_components
  has_many :sensors
  has_many :records
  has_many :variables, dependent: :destroy
  has_many :channels
  accepts_nested_attributes_for :variables

  def self.current
    Report.first
  end

  def active_sensor_story_components(opts={})
    Channel.sensorstory.text_components.select {|c| c.active?(opts) }
  end

  def active_text_components(opts={})
    text_components.select {|c| c.active?(opts) }
  end

  def archive!(intention: :real)
    new_record = compose(intention: intention)
    Report.transaction do
      if Record.send(intention).count >= Record::LIMIT
        Record.send(intention).first.destroy
      end
      new_record.save!
    end
  end

  def compose(opts={})
    generator = ::Text::Generator.new(report: self, opts: opts)
    generator.generate_record
  end

  def end_date
    if start_date && duration
      start_date + duration.days
    end
  end
end
