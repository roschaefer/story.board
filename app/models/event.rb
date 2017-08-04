class Event < ActiveRecord::Base
  has_many :activations, class_name: 'Event::Activation', dependent: :destroy
  has_and_belongs_to_many :triggers
  validates :name, presence: true, uniqueness: true

  def happened_at
    self.last_activation && self.last_activation.started_at
  end

  def name_and_id
    "#{name} (#{id})"
  end

  def start(timestamp = nil)
    given_timestamp = timestamp || DateTime.now
    unless self.active?
      Event::Activation.create!(event: self, started_at: given_timestamp)
      true
    else
      false
    end
  end

  def last_activation
    self.activations.order(:started_at).last
  end

  def stop(timestamp = nil)
    if self.active?
      given_timestamp = timestamp || DateTime.now
      la = self.last_activation
      la.ended_at = given_timestamp
      la.save!
      true
    else
      false
    end
  end

  def active?
    self.last_activation && self.last_activation.ended_at.nil?
  end
end
