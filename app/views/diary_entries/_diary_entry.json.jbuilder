json.extract! diary_entry, :id, :moment, :intention, :created_at, :updated_at
json.url report_diary_entry_url(@report, diary_entry, format: :json)
