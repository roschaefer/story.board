class ReportsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :present, :current]

  def current
    if @report
      if params[:preview]
        redirect_to preview_report_path(@report)
      else
        redirect_to present_report_path(@report)
      end
    else
      render :no_reports
    end
  end

  def present
    @live_record = @report.compose(intention: :real, at: query_params[:point_in_time])
    @archived_records = Record.real.order(:created_at).reverse_order
  end

  def preview
    @live_record = @report.compose(intention: :fake, at: query_params[:point_in_time])
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
  def query_params
    result = {}
    if params[:at]
      result[:point_in_time] = DateTime.parse(params[:at])
    else
      result[:point_in_time] = DateTime.now
    end
    result
  end

  def report_params
    params.require(:report).permit(:name, :start_date, :duration, :video, variables_attributes: [:value, :id])
  end
end
