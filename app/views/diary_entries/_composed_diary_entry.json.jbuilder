json.extract! diary_entry, :id, :moment, :intention
json.text_components do
  json.array!(diary_entry.text_components, partial: 'text_components/text_component', as: :text_component)
end
json.url report_diary_entry_url(@report, diary_entry, format: :json)
