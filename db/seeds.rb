# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#




if Report.count == 0
  # if there is no current report
  Report.create(name: 'Kuh Bertha', start_date: Time.now)
end

# Create default topics:

Topic.find_or_create_by(name: "milk_quantity")
Topic.find_or_create_by(name: "milk_quality")
Topic.find_or_create_by(name: "movement")
Topic.find_or_create_by(name: "temperature")
Topic.find_or_create_by(name: "intake")
Topic.find_or_create_by(name: "birth")
Topic.find_or_create_by(name: "calf")
Topic.find_or_create_by(name: "noise")
Topic.find_or_create_by(name: "health")

attribute_hashes = [
  { property: 'Temperature',          unit: '°C'     },
  { property: 'Atmospheric Pressure', unit: 'Bar'    },
  { property: 'Motion',               unit: '0-10'   },
  { property: 'Brightness',           unit: '0-10'   },
  { property: 'Volume',               unit: '0-10'   },
  { property: 'Humidity',             unit: '%'      },
  { property: 'Button',               unit: 'On/Off' },
  { property: 'Geophone',             unit: '?...?'  },
  { property: 'Gas: Methan',          unit: '%'      },
  { property: 'Gas: Alcohol',         unit: '%'      },
  { property: 'Gas: Ozone',           unit: '%'      },
  { property: 'Air quality',          unit: '?...?'  },
  { property: 'Vibration',            unit: '0-10'   },
  { property: 'Relative Humidity',    unit: '%'      },


  { property: 'Pedometer'         , unit: 'km'                                           },
  { property: 'Qualität'          , unit: 'Note 1-6'                                     },
  { property: 'Gesundheitsstatus' , unit: '0 -1 gesund/krank'                            },
  { property: 'Preis'             , unit: '€'                                            },
  { property: 'Zeit'              , unit: 'hours'                                        },
  { property: 'Milchmenge'        , unit: 'kg'                                           },
  { property: 'Lautstärke'        , unit: '0-10 - still, leise, mittel, laut, sehr laut' },
  { property: 'Favs'              , unit: '0-unlimited'                                  }
]

new_sensor_types = attribute_hashes.collect{ |attributes| SensorType.new attributes }
SensorType.find_each do |p|
  # avoid duplicates
  new_sensor_types.delete_if {|t| t.property == p.property && t.unit == p.unit }
end
new_sensor_types.each { |t| t.save! }


variable_hashes = [
  { report: Report.current , key: 'exemplar' , value: 'Bertha' }         ,
  { report: Report.current , key: 'bauer'    , value: 'Westrup' }        ,
  { report: Report.current , key: 'hof'      , value: 'Westrup - Koch' } ,
  { report: Report.current , key: 'kalb'     , value: 'Robert' }         ,
]

variable_hashes.each do |h|
  v = Variable.new(h)
  v.save
end
