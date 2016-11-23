class Trigger < ActiveRecord::Base
  belongs_to :report
  has_many :sensors, through: :conditions
  has_many :conditions, dependent: :destroy
  has_and_belongs_to_many :events
  has_and_belongs_to_many :text_components

  validates :report, presence: true
  validates :priority, presence: true
  accepts_nested_attributes_for :conditions, reject_if: :all_blank, allow_destroy: true

  enum priority: { low: 0, medium: 1, high: 2}
  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.priority ||= :medium
  end

  def active?(opts={})
    on_time? && conditions_fullfilled?(opts) && events_happened?
  end

  def on_time?
    result = true
    if from_hour && to_hour
      if from_hour <= to_hour
        result = (from_hour <= Time.now.hour ) && (Time.now.hour < to_hour)
      else
        # e.g. 21:00 -> 6:00
        result = (Time.now.hour < to_hour ) || (from_hour <= Time.now.hour)
      end
    end
    result
  end


  def conditions_fullfilled?(opts={})
    conditions.all? do |condition|
      reading = condition.last_reading(opts)
      if reading
        active = true
        active &= (condition.from.nil? || condition.from <= reading.calibrated_value)
        active &= (condition.to.nil? ||reading.calibrated_value < condition.to)
        active &= (timeliness_constraint.nil? || (timeliness_constraint.hours.ago <= reading.created_at))
        active
      else
        false
      end
    end
  end

  def events_happened?
    events.all? {|e| e.happened?}
  end
end
