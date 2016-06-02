class ReportsController < ApplicationController
  def current
    current_report = Report.current
    if current_report
      redirect_to present_report_path(current_report)
    else
      render :no_reports
    end
  end

  def present
    @report = Report.find(params[:id])
    @content = ""
    @report.sensors.each do |sensor|
      sensor.active_text_components.each do |component|
        @content <<  component.heading.to_s
        @content <<  component.introduction.to_s
        @content <<  component.main_part.to_s
        @content <<  component.closing.to_s
      end
    end
  end

  def edit
    @report = Report.find(params[:id])
  end

  def show
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    if @report.update(report_params)
      redirect_to @report
    else
      render 'new'
    end
  end

  private

  def report_params
    params.require(:report).permit(:start_date)
  end
end
