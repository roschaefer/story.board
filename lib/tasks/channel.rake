namespace :channel do
  desc "Create Default Topics and channel"
  task :create_default => :environment do

    Topic.find_or_create_by(name: "milk_quantity")
    Topic.find_or_create_by(name: "milk_quality")
    Topic.find_or_create_by(name: "movement")
    Topic.find_or_create_by(name: "temperature")
    Topic.find_or_create_by(name: "intake")
    Topic.find_or_create_by(name: "birth")
    Topic.find_or_create_by(name: "calf")
    Topic.find_or_create_by(name: "noise")
    Topic.find_or_create_by(name: "health")

    Report.find_each do |report|
      default_channel = Channel.find_or_create_by(
        report: report,
        name: "sensorstory"
      ) do |c|
        c.description = "Default Channel"
      end

      report.text_components.each do |text_component|
        text_component.channels << default_channel unless text_component.channels.include?(default_channel)
      end
    end
  end
end
