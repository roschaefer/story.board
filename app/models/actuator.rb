class Actuator < ActiveRecord::Base
  has_many :commands
  validates :name, presence: true, uniqueness: true

  def activate!(synchronous: false)
    c = Command.create!(actuator: self, executed: false, value: :on)
    if synchronous
      c.run!
    end
  end
end
