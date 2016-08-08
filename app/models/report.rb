class Report < ActiveRecord::Base
  has_many :text_components
  has_many :sensors
  has_many :records
  has_many :variables, dependent: :destroy
  accepts_nested_attributes_for :variables

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
    generator = Text::Generator.new(self, intention)
    generated = generator.generate
    Record.new(generated.merge(report: self, intention: intention))
  end
end
