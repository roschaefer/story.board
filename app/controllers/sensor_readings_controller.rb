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

  private

  def sensor_reading_params
    assign_sensor_by_name
    params.require(:sensor_reading).permit(:sensor_id, :sensor_name, :calibrated_value, :uncalibrated_value)
  end

  def assign_sensor_by_name
    sensor_name = params[:sensor_name]
    sensor_id = params[:sensor_id]
    if sensor_name && sensor_id.nil?
      params[:sensor_reading][:sensor_id] = Sensor.find_by(:name => sensor_name).id
    end
  end

end

