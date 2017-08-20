class Event < ActiveRecord::Base
  has_many :activations, class_name: 'Event::Activation', dependent: :destroy
  has_and_belongs_to_many :triggers
  validates :name, presence: true, uniqueness: true

  def self.default_scope
    order('LOWER("events"."name")')
  end

  def active_activation_at(time)
    self.activations.active(time).first
  end

  def name_and_id
    "#{name} (#{id})"
  end

  def last_activation
    self.activations.order(:started_at).last
  end

  def start(timestamp = nil)
    given_timestamp = timestamp || Time.now
    return if self.active?(timestamp)
    Event::Activation.create!(event: self, started_at: given_timestamp)
  end

  def stop(timestamp = nil)
    return unless self.active?
    given_timestamp = timestamp || Time.now
    la = self.active_activation_at(given_timestamp)
    la.ended_at = given_timestamp
    la.save!
  end

  def active?(moment = nil)
    moment ||= Time.now
    !! self.active_activation_at(moment)
  end
end
