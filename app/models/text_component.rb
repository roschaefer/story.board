class TextComponent < ActiveRecord::Base
  belongs_to :report
  has_many :sensors, through: :conditions
  has_and_belongs_to_many :events
  has_many :conditions

  validates :heading, :main_part, presence: true
  validates :report, presence: true
  accepts_nested_attributes_for :conditions, reject_if: :all_blank, allow_destroy: true

  enum priority: { low: 0, medium: 1, high: 2}
  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.priority ||= :medium
  end

  def active?(intention: :real, at: DateTime.now)
    conditions_fullfilled?(intention: intention, at: at) && events_happened?
  end


  def conditions_fullfilled?(intention: :real, at: DateTime.now)
    conditions.all? do |condition|
      reading = condition.last_reading(intention: intention, at: at)
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
