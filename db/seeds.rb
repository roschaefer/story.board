# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#



attribute_hashes = [
  { :property =>"Temperature", :unit => "°C" },
  { :property =>"Atmospheric Pressure", :unit => "Bar" },
  { :property =>"Motion", :unit => "0-10" },
  { :property =>"Brightness", :unit => "0-10" },
  { :property =>"Volume", :unit => "0-10" },
  { :property =>"Humidity", :unit => "%" },
  { :property =>"Button", :unit => "On/Off" },
  { :property =>"Geophone", :unit => "?...?" },
  { :property =>"Gas: Methan", :unit => "%" },
  { :property =>"Gas: Alcohol", :unit => "%" },
  { :property =>"Gas: Ozone", :unit => "%" },
  { :property =>"Air quality", :unit => "?...?" },
  { :property =>"Vibration", :unit => "0-10" },
  { :property =>"Relative Humidity" , :unit => "%" },
]

attribute_hashes.each  { |attributes| SensorType.create attributes }
