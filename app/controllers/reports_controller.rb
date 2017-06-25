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
    @live_entry = DiaryEntry.new(report: @report, intention: :real, moment: query_params[:point_in_time]).compose
    @archived_entries = DiaryEntry.real.order(:created_at).reverse_order.collect do |entry|
      entry.compose
    end
  end

  def preview
    @live_entry = DiaryEntry.new(report: @report, intention: :fake, moment: query_params[:point_in_time]).compose
    @archived_entries = DiaryEntry.fake.order(:created_at).reverse_order.collect do |entry|
      entry.compose
    end
    render 'present'
  end

  def update
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
