class ChannelsController < ApplicationController
  before_action :set_channel, only: [:edit, :update]

  def show
    @response = {
      messages: [
        { text: "If you think there is good in everybody, you haven't met everybody."}
      ]
    }
    render json: @response.to_json
  end

  def edit
  end

  def update
    respond_to do |format|
      if @channel.update(channel_params)
        format.html { redirect_to edit_report_channel_path(@channel), notice: 'Channel was successfully updated.' }
        format.json { render :edit, status: :ok, location: @channel }
      else
        format.html { render :edit }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def channel_params
    params.require(:channel).permit(:name, :description)
  end

  def set_channel
    @channel = Channel.find_by(id: params[:id], report_id: params[:report_id])
  end
end
