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
    @report = Report.find(params[:id])
    @live_record = @report.compose(:real)
    @archived_records = Record.real
  end

  def preview
    @report = Report.find(params[:id])
    @live_record = @report.compose(:fake)
    @archived_records = Record.fake
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
    params.require(:report).permit(:name, :start_date, :video)
  end
end
