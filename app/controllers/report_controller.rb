class ReportController < ApplicationController
  def show
    @content = ""
    Sensor.find_each do |sensor|
      sensor.active_text_components.each do |component|
        @content <<  component.heading.to_s
        @content <<  component.introduction.to_s
        @content <<  component.main_part.to_s
        @content <<  component.closing.to_s
      end
    end

  end
end
