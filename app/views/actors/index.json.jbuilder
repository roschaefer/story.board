json.array!(@actors) do |actor|
  json.extract! actor, :id, :name, :port, :function
  json.url actor_url(actor, format: :json)
end
