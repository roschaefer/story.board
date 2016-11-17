class TextComponent < ActiveRecord::Base
  validates :heading, :report, presence: true
  has_and_belongs_to_many :triggers
  has_many :sensors, through: :triggers
  has_many :events, through: :triggers
  belongs_to :report

  def active?(opts={})
    on_time? && triggers.all? {|t| t.active?(opts) }
  end

  def on_time?
    result = true
    if from_day
      result &= ((report.start_date + from_day.days) <= Time.now)
    end
    if to_day
      result &= (Time.now <= (report.start_date + to_day.days))
    end
    result
  end

  def priority
    most_important_trigger = triggers.sort_by {|t| Trigger.priorities[t.priority] }.reverse.first
    most_important_trigger && most_important_trigger.priority
  end
end
