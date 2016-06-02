class Report < ActiveRecord::Base
  has_many :text_components
  has_many :sensors

  def self.current
    Report.first
  end
end
