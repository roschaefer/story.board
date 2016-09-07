class Report < ActiveRecord::Base
  TIME_ZONE   = 'Europe/Berlin'
  DATE_FORMAT = '%-d.%-m.%Y'
  DATE_TIME_FORMAT = "#{DATE_FORMAT}, %H:%M Uhr"


  has_many :text_components
  has_many :sensors
  has_many :records
  has_many :variables, dependent: :destroy
  accepts_nested_attributes_for :variables

  def self.current
    Report.first
  end

  def active_text_components(intention: :real, at: DateTime.now)
    text_components.select {|c| c.active?(intention: intention, at: at) }
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

  def compose(intention: :real, at: DateTime.now)
    generator = Text::Generator.new(intention: intention, at: at, report: self)
    generated = generator.generate
    Record.new(generated.merge(report: self, intention: intention))
  end
end
