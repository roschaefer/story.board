class Actor < ActiveRecord::Base
  has_many :commands
  validates :name, presence: true, uniqueness: true

  def activate!
    Command.create!(actor: self, executed: false, value: :on)
  end
end
