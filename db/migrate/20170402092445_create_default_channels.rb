class CreateDefaultChannels < ActiveRecord::Migration[5.0]
  class Channel < ActiveRecord::Base
    belongs_to :report
  end

  class Report < ActiveRecord::Base
  end

  def change
    # make sure at least one report is there
    Report.find_or_create_by(name: 'Kuh Bertha') do |r|
      r.start_date = Time.now
    end

    # for every report, create default channels
    Report.find_each do |report|
      ["sensorstory", "chatbot"].each do |channel_name|
        Channel.find_or_create_by(name: channel_name, report: report)
      end
    end
  end
end
