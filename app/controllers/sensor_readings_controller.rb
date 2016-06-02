class SensorReadingsController < ApplicationController

  def create
    @sensor_reading = Sensor::Reading.new(sensor_reading_params)
    respond_to do |format|
      if @sensor_reading.save
        format.json { render :json => @sensor_reading, status: :created, location: @sensor_reading }
      else
        format.json { render json: @sensor_reading.errors, status: :unprocessable_entity }
      end
    end
  end

  def generate_sample_data
    value = rand(sample_params[:from].to_i..sample_params[:to].to_i)
    sample_params[:quantity].to_i.times do
      Sensor::Reading.create(:sensor_id => sample_params[:sensor_id], :calibrated_value => value)
    end
    render :nothing => true, :status => :created
  end

  private

  def sample_params
    params.require(:fake).permit(:sensor_id, :quantity, :from, :to)
  end

  def sensor_reading_params
    assign_sensor_by_name
    params.require(:sensor_reading).permit(:sensor_id, :sensor_name, :calibrated_value, :uncalibrated_value)
  end

  def assign_sensor_by_name
    sensor_name = params[:sensor_name]
    sensor_id = params[:sensor_id]
    if sensor_name && sensor_id.nil?
      params[:sensor_reading][:sensor_id] = Sensor.find_by(:name => sensor_name).try(:id)
      params[:sensor_reading].delete(:sensor_name)
    end
  end

end

