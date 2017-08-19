class Trigger < ActiveRecord::Base
  belongs_to :report
  has_many :sensors, through: :conditions
  has_many :conditions, dependent: :destroy
  has_and_belongs_to_many :events
  has_and_belongs_to_many :text_components

  validates :report, presence: true
  validates :priority, presence: true
  accepts_nested_attributes_for :conditions, reject_if: :all_blank, allow_destroy: true

  enum priority: { very_low: -1, low: 0, medium: 1, high: 2, urgent: 3}

  def self.default_scope
    order('LOWER("triggers"."name")')
  end

  def active?(diary_entry = nil)
    conditions_fullfilled?(diary_entry) && events_active?(diary_entry)
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
end
