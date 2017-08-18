class SensorDecorator

  def initialize(sensor)
    @sensor = sensor
  end

  def last_value(diary_entry = nil)
    r = @sensor.last_reading(diary_entry)
    u = @sensor.sensor_type.unit

    if r
      v = r.calibrated_value
      "#{format("%.1f", v)} #{u}"
    else
      "(Sorry, leider habe ich gerade keine Daten für dich!)"
    end
  end

  def method_missing(m, *args, &block)
    @sensor.send(m, *args, &block)
  end
end
