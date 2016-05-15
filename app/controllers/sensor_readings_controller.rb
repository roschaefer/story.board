class SensorReadingsController < ApplicationController

  def create
    @sensor_reading = SensorReading.new(sensor_reading_params)
    respond_to do |format|
      if @sensor_reading.save
        format.json { render :json => @sensor_reading, status: :created, location: @sensor_reading }
      else
        format.json { render json: @sensor_reading.errors, status: :unprocessable_entity }
      end
    end
  end

  def sensor_reading_params
    params.require(:sensor_reading).permit(:sensor_id, :calibrated_value, :uncalibrated_value)
  end
end

