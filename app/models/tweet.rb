class Tweet < ActiveRecord::Base
  belongs_to :chain
  belongs_to :command

  validates :user, presence: true
  delegate :actuator, to: :chain
  delegate :function, to: :chain

  before_create :assign_chain
  after_create :create_command


  REGEX = /(?:\s|^)(?:#(?!(?:\d+|\w+?_|_\w+?)(?:\s|$)))(\w+)(?=\s|$)/i

  def hashtags
    message.scan(REGEX).flatten
  end

  private

  def assign_chain
    unless chain
      self.chain = Chain.find_by(hashtag: hashtags)
    end
  end

  def create_command
    if actuator
      self.command = Command.new(
        function: function,
        actuator: actuator,
        status: :pending,
        tweet: self
      )
      self.command.save
    end
  end

end
