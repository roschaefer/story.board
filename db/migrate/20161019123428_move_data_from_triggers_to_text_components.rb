class MoveDataFromTriggersToTextComponents < ActiveRecord::Migration
  def up
    Trigger.find_each do |t|
      TextComponent.create!(
        heading: t.heading,
        introduction: t.introduction,
        main_part: t.main_part,
        closing: t.closing,
        triggers: [t]
      )
    end

    rename_column :triggers, :heading, :name
    remove_column :triggers, :introduction
    remove_column :triggers, :main_part
    remove_column :triggers, :closing

  end
end
