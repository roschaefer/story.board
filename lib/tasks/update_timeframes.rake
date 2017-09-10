namespace :sensorstory do
  desc "Update text_component timeframes (from and to hour)"
  task :update_timeframes => :environment do
    TextComponent.transaction do
      TextComponent.where(from_hour: 18, to_hour: 23).update_all(to_hour: 0)
      TextComponent.where(from_hour: 23, to_hour: 6).update_all(from_hour: 0)
    end
  end
end
