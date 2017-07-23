class Sensor
  class Reading < ActiveRecord::Base
    enum release: [:final, :debug]
    belongs_to :sensor
    validates :sensor, presence: true
    validates :calibrated_value, presence: true
    validates :uncalibrated_value, presence: true

    scope :created_before, -> (time) { where('created_at <= ?', time) }
  end
end
