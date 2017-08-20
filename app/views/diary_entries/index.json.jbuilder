json.array! [@live_entry], partial: 'diary_entries/live_entry', as: :diary_entry if @live_entry
json.array! @diary_entries, partial: 'diary_entries/diary_entry', as: :diary_entry
