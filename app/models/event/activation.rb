class Event::Activation < ApplicationRecord
  belongs_to :event, required: true

  validates :started_at, presence: true
  validate :ends_after_start
  validate :not_overlapping

  def duration
    self.ended_at && self.ended_at - self.started_at
  end

  def active?
    self.ended_at.nil?
  end

  private

  def ends_after_start
    if self.ended_at && self.started_at && (self.ended_at < self.started_at)
      errors.add(:ended_at, "can't end before started")
    end
  end

  def not_overlapping
    if self.started_at
        overlapping_activation = Event::Activation.where(event: self.event).where.not(id: self.id).where('ended_at > ?', self.started_at)
      if self.ended_at
        overlapping_activation = overlapping_activation.where('started_at < ?', self.ended_at)
      end
      unless overlapping_activation.empty?
        errors.add(:started_at, "time span overlaps with another activation")
        errors.add(:ended_at, "time span overlaps with another activation")
      end
    end
  end
end
