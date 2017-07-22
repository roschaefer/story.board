namespace :sensorstory do
  desc "Add min, max and fractionDigits to certain sensor types"
  task :update_sensortypes => :environment do
    SensorType.transaction do
      SensorType.where(unit: '?...?').update_all(unit: nil)
      SensorType.where(unit: '0-10').update_all(unit: nil)
      SensorType.where(unit: '1-10').update_all(unit: nil)
      SensorType.where(unit: '1-100').update_all(unit: nil)
      SensorType.where(unit: '0-unlimited').update_all(unit: nil)
      SensorType.where(unit: '').update_all(unit: nil)
      SensorType.find_by!(property: 'Temperature').update_attributes!(min: -10.0, max: 45.0, fractionDigits: 1, unit: '°C')
      SensorType.find_by!(property: 'pH Value').update_attributes!(min: -10.0, max: 45.0, fractionDigits: 1, unit: '')
      SensorType.find_by!(property: 'pH Value').update_attributes!(min: 0.0, max: 14.0, fractionDigits: 1, unit: '')

      #SensorType.find_by('Temperature-Humidity-Index').update_attributes!(min: 1, max: 100, fractionDigits: 0)
      SensorType.find_by!(property: 'Milchmenge').update_attributes!(min: 0.0, max: 80.0, fractionDigits: 1, unit: 'Liter')
      SensorType.find_by!(property: 'Movement').update_attributes!(min: 0, max: 100, fractionDigits: 0, unit: '%') # or should it be "Pedometer"?
      SensorType.find_by!(property: 'Humidity').update_attributes!(min: 0, max: 100, fractionDigits: 0, unit: '%') # or should it be "Relative Humidity"?
      SensorType.find_by!(property: 'Preis').update_attributes!(min: 0, max: 200, fractionDigits: 0, unit: 'Cent')

      SensorType.find_by!(unit: '0 -1 gesund/krank').update_attributes!(min: 0, max: 1, fractionDigits: 0, unit: 'gesund/krank')
      SensorType.find_by!(unit: '0-10 - still, leise, mittel, laut, sehr laut').update_attributes!(min: 0, max: 10, fractionDigits: 0, unit: 'Geräuschpegel')
      SensorType.find_by!(unit: 'Note 1-6').update_attributes!(min: 1, max: 6, fractionDigits: 0, unit: 'Note')
    end
  end
end
