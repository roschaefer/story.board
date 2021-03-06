class DiaryEntriesController < ApplicationController
  before_action :set_diary_entry, only: [:show,]
  before_action :authenticate_user!, except: %i[index show]
  include CommonFilters

  self.page_cache_directory = -> { Rails.root.join('public') }
  caches_page :show

  def index
    from_and_to_params_are_dates(filter_params) or return
    @diary_entries = DiaryEntry.where(report: @report).order(:moment)
    @diary_entries = filter_release(@diary_entries, filter_params)
    @diary_entries = filter_timestamp(@diary_entries, filter_params, 'moment')
    unless filter_params[:from] || filter_params[:to]
      release = params[:release] || :final
      @live_entry = DiaryEntry.new(report: @report, release: release, id: 0)
    end
    @diary_entries
  end

  def show
  end

  private
  def set_diary_entry
    if (params[:id] == '0')
      @diary_entry = DiaryEntry.new(report: @report, release: :final, id: 0, moment: Time.zone.now)
    else
      @diary_entry = DiaryEntry.find(params[:id])
    end
  end

  def filter_params
    params.permit(:from, :to, :release)
  end
end
