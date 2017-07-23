class DiaryEntriesController < ApplicationController
  before_action :set_diary_entry, only: [:show,]
  before_action :filter_diary_entries, only: [:index,]

  def index
  end

  def show
  end

  private
  def diary_entries
    DiaryEntry.where(report: @report).order(:moment)
  end

  def set_diary_entry
    @diary_entry = DiaryEntry.find(params[:id])
  end

  def filter_diary_entries
    @diary_entries = diary_entries
    if filter_params[:release]
      @diary_entries = @diary_entries.where(release: filter_params[:release])
    end
    if filter_params[:from] && filter_params[:to]
      @diary_entries = @diary_entries.where('moment > ?',  filter_params[:from])
      @diary_entries = @diary_entries.where('moment < ?',  filter_params[:to])
    end
  end

  def filter_params
    params.permit(:from, :to, :release)
  end
end
