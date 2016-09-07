class ChangeMarkupFromSensorNameToSensorId < ActiveRecord::Migration
  def up
    sensor_name_typos = {
      'Milchqualitaet-Sunshine' => 'Milchqualität-Sunshine',
      'Laufleistung-Sunshine' => 'Laufleistung–Sunshine-HofWestrup',
      'Laufleistung-Sunshine-HofWestrup' => 'Laufleistung–Sunshine-HofWestrup',
      'milchpreis-sunshine' => 'MilchpreisSunshine',
      'Temp.1-Stalltemperatur-Sunshine–HofWestrup' => 'TEMP.1-Stalltemperatur-Sunshine–HofWestrup',
      'Milchmenge.Herde-Sunshine-HofWestrup' => 'MilchmengeHerde',
      'Methan.1-MethanimStall-Sunshine–HofWestrup' => 'METHAN.1',
      'taeglichefresszeitsunshine' => 'TaeglicheFresszeitSunshine',
      'FavsInSocial-Sunshine-HofWestrup' => 'FavsInSocial-Sunshine',
      'MilchmengeHerde' => 'MilchmengeHerde',
      'Milchmenge-Sunshine' => 'Milchmenge-Sunshine',
    }

    TextComponent.find_each do |t|
      t.sensors.each do |s|
        t.introduction = t.introduction.gsub(/({\s*#{ Regexp.quote(s.name) }\s*})/, "{ value(#{s.id}) }")
        t.main_part = t.main_part.gsub(/({\s*#{ Regexp.quote(s.name) }\s*})/, "{ value(#{s.id}) }")
        t.closing = t.closing.gsub(/({\s*#{ Regexp.quote(s.name) }\s*})/, "{ value(#{s.id}) }")
        t.save!
      end

      sensor_name_typos.each do |typo, name|
        s = Sensor.find_by(name: name)
        if s
          t.introduction = t.introduction.gsub(/({\s*#{ Regexp.quote(typo) }\s*})/, "{ value(#{s.id}) }")
          t.main_part = t.main_part.gsub(/({\s*#{ Regexp.quote(typo) }\s*})/, "{ value(#{s.id}) }")
          t.closing = t.closing.gsub(/({\s*#{ Regexp.quote(typo) }\s*})/, "{ value(#{s.id}) }")
          t.save!
        end
      end
    end
  end
end
