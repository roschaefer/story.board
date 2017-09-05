class SensorDecorator

  def initialize(sensor, diary_entry)
    @diary_entry = diary_entry
    @sensor = sensor
  end

  def last_value
    r = @sensor.last_reading(@diary_entry)
    u = @sensor.sensor_type.unit

    if r
      v = r.calibrated_value
      "%<value>.#{r.sensor.fractionDigits}f %<unit>s" % {value: v, unit: u}
    else
      "(Sorry, leider habe ich gerade keine Daten für dich!)"
    end
  end

  def method_missing(m, *args, &block)
    @sensor.send(m, *args, &block)
  end
end
