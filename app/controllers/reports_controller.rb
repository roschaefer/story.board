class ReportsController < ApplicationController
  def current
    current_report = Report.current
    if current_report
      if params[:preview]
        redirect_to preview_report_path(current_report)
      else
        redirect_to present_report_path(current_report)
      end
    else
      render :no_reports
    end
  end

  def present
    generate_report(:real)
  end

  def preview
    generate_report(:fake)
    render 'present'
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

  def generate_report(source)
    @report = Report.find(params[:id])
    @content = ""
    @report.sensors.each do |sensor|
      sensor.active_text_components(source).each do |component|
        @content <<  component.heading.to_s
        @content <<  component.introduction.to_s
        @content <<  component.main_part.to_s
        @content <<  component.closing.to_s
      end
    end
  end
end
