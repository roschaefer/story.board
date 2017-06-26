class DiaryEntriesController < ApplicationController
  before_action :set_diary_entry, only: [:show,]

  def index
    @diary_entries = DiaryEntry.all
  end

  def show
  end

  private
    def set_diary_entry
      @diary_entry = DiaryEntry.find(params[:id])
    end
end
