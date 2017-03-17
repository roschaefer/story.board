class Channel < ActiveRecord::Base
  has_and_belongs_to_many :text_components
  belongs_to :report

  def self.default(report)
    find_by(name: "sensorstory", report: report)
  end
end
