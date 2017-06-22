class SensorType < ActiveRecord::Base
  enum property: [:temperature, :atmospheric_pressure, :motion, :brightness, :volume, :humidity, :button, :geophone, :gas_methan, :gas_alcohol,
    :gas_ozone, :air_quality, :vibration, :relative_humidity, :pedometer, :quality, :health_status, :price, :time, :milk_amount, :volume, :favs]
end
