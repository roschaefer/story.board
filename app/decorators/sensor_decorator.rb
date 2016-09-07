class SensorDecorator

  def initialize(sensor)
    @sensor = sensor
  end

  def last_value(at: DateTime.now, intention: :real)
    r = @sensor.last_reading(at: at, intention: intention)
    v = r.calibrated_value
    u = @sensor.sensor_type.unit
    "#{format("%.1f", v)}#{u}"
  end

  def method_missing(m, *args, &block)
    @sensor.send(m, *args, &block)
  end
end
