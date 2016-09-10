json.array!(@actuator) do |actuator|
  json.extract! actuator, :id, :name, :port
  json.url actuator_url(actuator, format: :json)
end
