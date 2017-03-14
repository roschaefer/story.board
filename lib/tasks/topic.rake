namespace :topic do
  desc "Create Default Topics"
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
  end
end
