class SensorDecorator

  def initialize(sensor, source = :real)
    @sensor = sensor
    @source = source
  end

  def last_value
    r = @sensor.sensor_readings.send(@source).last
    v = r.calibrated_value
    u = @sensor.sensor_type.unit
    "#{format("%.1f", v)}#{u}"
  end

  def method_missing(m, *args, &block)
    @sensor.send(m, *args, &block)
  end
end
