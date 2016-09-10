class Actuator < ActiveRecord::Base
  has_many :commands
  validates :name, presence: true, uniqueness: true

  def activate!
    Command.create!(actuator: self, executed: false, value: :on)
  end
end
