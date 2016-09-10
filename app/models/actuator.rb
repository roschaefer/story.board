class Actuator < ActiveRecord::Base
  has_many :commands
  validates :name, presence: true, uniqueness: true

  def activate!(synchronous: false)
    c = Command.create!(actuator: self, function: :activate)
    if synchronous
      c.run!
    end
  end

  def deactivate!(synchronous: false)
    c = Command.create!(actuator: self, function: :deactivate)
    if synchronous
      c.run!
    end
  end
end
