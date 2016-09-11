json.array!(@chains) do |chain|
  json.extract! chain, :id, :actuator_id, :function, :hashtag
  json.url chain_url(chain, format: :json)
end
