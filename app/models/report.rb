class Report < ActiveRecord::Base
  has_many :text_components
  has_many :sensors
  has_many :records

  def self.current
    Report.first
  end

  def active_text_components(source = :real)
    text_components.select {|c| c.active?(source) }
  end

  def archive!(intention = :real)
    new_record = compose(intention) 
    Report.transaction do
      if Record.send(intention).count >= Record::LIMIT
        Record.send(intention).first.destroy
      end
      new_record.save!
    end
  end

  def compose(intention = :real)
    generated = Text::Generator.generate(self, intention)
    Record.new(generated.merge(report: self, intention: intention))
  end
end
