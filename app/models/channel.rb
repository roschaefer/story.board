class Channel < ActiveRecord::Base
  has_and_belongs_to_many :text_components

  scope :chatbot,     -> { find_by(name: "chatbot") }
  scope :sensorstory, -> { find_by(name: "sensorstory") }

  validates :name, presence: true, uniqueness: true

  def self.default_scope
    order('LOWER("channels"."name")')
  end

  def self.default
    Channel.sensorstory
  end
end
