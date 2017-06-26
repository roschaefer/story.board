json.extract! diary_entry, :id, :moment, :intention
json.url report_diary_entry_url(@report, diary_entry, format: :json)
