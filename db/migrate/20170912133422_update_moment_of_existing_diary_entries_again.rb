class UpdateMomentOfExistingDiaryEntriesAgain < ActiveRecord::Migration[5.0]
  def change
    DiaryEntry.find_each do |entry|
      if entry.moment.hour == 23
        entry.moment += 1.hour
        entry.save!
      end
    end
  end
end
