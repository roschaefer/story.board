class InitializeDefaultChannel < ActiveRecord::Migration[5.0]
  class Channel < ActiveRecord::Base
    has_and_belongs_to_many :text_components
    belongs_to :report
  end

  class Report < ActiveRecord::Base
    has_many :channels
    has_many :text_components
  end

  class TextComponent < ActiveRecord::Base
    has_and_belongs_to_many :channels
  end

  def up
    Report.all.each do |report|
      default_channel = Channel.create!(
        report: report,
        name: "storyboard",
        description: "Default Channel"
      )

      report.text_components.each do |text_component|
        text_component.channels << default_channel
      end
    end
  end

  def down
    Channel.destroy_all
  end
end
