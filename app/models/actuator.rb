class Actuator < ActiveRecord::Base
  has_many :commands
  validates :name, presence: true, uniqueness: true

  def activate!
    c = Command.create!(actuator: self, executed: false, value: :on)
    c.run!
  end
end
