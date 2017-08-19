class Trigger < ActiveRecord::Base
  belongs_to :report
  has_many :sensors, through: :conditions
  has_many :conditions, dependent: :destroy
  has_and_belongs_to_many :events
  has_and_belongs_to_many :text_components

  validates :report, presence: true
  validates :priority, presence: true
  validates :from_hour, inclusion: { in: 0..23 }, allow_blank: true
  validates :to_hour, inclusion: { in: 0..23 }, allow_blank: true
  validate :both_hours_are_given
  accepts_nested_attributes_for :conditions, reject_if: :all_blank, allow_destroy: true

  enum priority: { very_low: -1, low: 0, medium: 1, high: 2, urgent: 3}

  def self.default_scope
    order('LOWER("triggers"."name")')
  end

  def active?(diary_entry = nil)
    on_time? && conditions_fullfilled?(diary_entry) && events_active?(diary_entry)
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


  def conditions_fullfilled?(diary_entry = nil)
    conditions.all? do |condition|
      reading = condition.last_reading(diary_entry)
      if reading
        active = true
        active &= (condition.from.nil? || condition.from <= reading.calibrated_value)
        active &= (condition.to.nil? ||reading.calibrated_value < condition.to)
        active &= (validity_period.nil? || (validity_period.hours.ago <= reading.created_at))
        active
      else
        false
      end
    end
  end

  def events_active?(diary_entry = nil)
    events.all? {|e| e.active?(diary_entry&.moment)}
  end


  private
  def both_hours_are_given
    if from_hour && to_hour.blank?
      errors.add(:to_hour, "is missing")
    end
    if to_hour && from_hour.blank?
      errors.add(:from_hour, "is missing")
    end
  end
end
