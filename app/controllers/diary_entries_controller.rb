class DiaryEntriesController < ApplicationController
  before_action :set_diary_entry, only: [:show,]
  include CommonFilters

  def index
    from_and_to_params_are_dates(filter_params) or return
    @diary_entries = DiaryEntry.where(report: @report).order(:moment)
    @diary_entries = filter_release(@diary_entries, filter_params)
    @diary_entries = filter_timestamp(@diary_entries, filter_params, 'moment')
    @diary_entries
  end

  def show
  end

  private
  def set_diary_entry
    @diary_entry = DiaryEntry.find(params[:id])
  end

  def filter_params
    params.permit(:from, :to, :release)
  end
end
