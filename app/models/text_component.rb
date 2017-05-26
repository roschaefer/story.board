class TextComponent < ActiveRecord::Base
  validates :heading, :report, presence: true
  has_and_belongs_to_many :triggers
  has_many :sensors, through: :triggers
  has_many :events, through: :triggers
  has_and_belongs_to_many :channels
  belongs_to :report
  belongs_to :topic
  belongs_to :assignee, class_name: 'User'
  has_many :question_answers, inverse_of: :text_component
  accepts_nested_attributes_for :question_answers, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :triggers

  validates :channels, presence: true

  delegate :name, to: :topic, prefix: true, allow_nil: true
  delegate :name, to: :assignee, prefix: true, allow_nil: true

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

  def priority_index
    Trigger.priorities[priority]
  end

  def priority
    most_important_trigger = triggers.sort_by {|t| Trigger.priorities[t.priority] }.reverse.first
    most_important_trigger && most_important_trigger.priority
  end
end
