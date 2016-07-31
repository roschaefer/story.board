class SensorDecorator

  def initialize(sensor, intention = :real)
    @sensor = sensor
    @intention = intention
  end

  def last_value
    r = @sensor.sensor_readings.send(@intention).last
    v = r.calibrated_value
    u = @sensor.sensor_type.unit
    "#{format("%.1f", v)}#{u}"
  end

  def method_missing(m, *args, &block)
    @sensor.send(m, *args, &block)
  end
end
