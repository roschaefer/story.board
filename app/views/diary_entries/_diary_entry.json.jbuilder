json.extract! diary_entry, :id, :moment, :release
json.url report_diary_entry_url(@report, diary_entry, format: :json)
