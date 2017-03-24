class Channel < ActiveRecord::Base
  has_and_belongs_to_many :text_components
  belongs_to :report

  scope :chatbot,     -> { find_by(report: Report.current, name: "chatbot") }
  scope :sensorstory, -> { find_by(report: Report.current, name: "sensorstory") }

  validates :report, presence: true

  def self.default(report)
    Channel.sensorstory
  end
end
