class ChannelsController < ApplicationController
  before_action :set_channel, only: [:edit, :update]
  before_action :authenticate_user!, only: [:edit, :update] unless Rails.env.test?

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @channel.update(channel_params)
        format.html { redirect_to edit_channel_path(@channel), notice: 'Channel was successfully updated.' }
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
    @channel = Channel.find_by(id: params[:id])
  end
end
