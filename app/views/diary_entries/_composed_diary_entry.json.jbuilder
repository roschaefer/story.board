json.extract! diary_entry, :id, :moment, :release
json.text_components do
  json.array!(diary_entry.rendered_text_components, partial: 'text_components/text_component', as: :text_component)
end
json.url report_diary_entry_url(@report, diary_entry, format: :json)
