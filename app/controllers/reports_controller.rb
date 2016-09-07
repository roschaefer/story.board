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
    if params[:at]
      point_in_time = DateTime.parse(params[:at])
    else
      point_in_time = DateTime.now
    end
    @live_record = @report.compose(intention: :real, at: point_in_time)
    @archived_records = Record.real.order(:created_at).reverse_order
  end

  def preview
    @report = Report.find(params[:id])
    @live_record = @report.compose(intention: :fake)
    @archived_records = Record.fake.order(:created_at).reverse_order
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
    params.require(:report).permit(:name, :start_date, :video, variables_attributes: [:value, :id])
  end
end
