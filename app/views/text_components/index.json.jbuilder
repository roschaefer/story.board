json.array!(@text_components) do |text_component|
  json.extract! text_component, :id, :heading, :introduction, :main_part, :closing, :from_day, :to_day
  json.url text_component_url(text_component, format: :json)
end
