class TextComponent < ActiveRecord::Base
  validates :heading, :report, presence: true
  has_and_belongs_to_many :triggers
  has_many :sensors, through: :triggers
  has_many :events, through: :triggers
  has_and_belongs_to_many :channels
  belongs_to :report
  belongs_to :topic

  accepts_nested_attributes_for :triggers

  before_create :assign_default_channel

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

  private

  def assign_default_channel
    if self.channels.empty?
      default_channel = Channel.default(report)
      self.channels << default_channel if default_channel
    end
  end
end
