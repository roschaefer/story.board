namespace :sensorstory do

  desc 'Add or rename a list of german topics'
  task add_german_topics: :environment do
    Topic.transaction do
      not_matched = [
        "movement",
        "temperature",
        "noise",
      ]
      added = {
        'news' => "Breaking News",
        'farmlife' => "Hofleben",
        'backup-cow' => "Backup-Kuh",
        'technology' => "Technologie",
        'daily-life' => "Kuhalltag",
        'social-behaviour' => "Sozialverhalten",
        'heat-and-insemination' => "Brunst_und_Besamung",
        'politics-ethics' => "Politik_Ethik",
        'economy' => "Wirtschaft (Milchpreis)",
        'curiosities' => "Kurioses",
      }
      matched = {
        'calf' => "Kalb",
        'birth' => "Abkalbung",
        'health' => "Gesundheit",
        'milk_quantity' => "Milchmenge",
        'milk_quality' =>"Milchqualität",
        'intake' => "Fütterung",
      }

      added.each do |name, display_name|
        Topic.create!(name: name, display_name: display_name)
      end

      matched.each do |name, display_name|
        topic = Topic.find_by!(name: name)
        topic.display_name = display_name
        topic.save!
      end
    end
  end
end
