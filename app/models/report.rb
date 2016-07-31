class Report < ActiveRecord::Base
  has_many :text_components
  has_many :sensors

  def self.current
    Report.first
  end

  def active_text_components(source = :real)
    text_components.select {|c| c.active?(source) }
  end
end
