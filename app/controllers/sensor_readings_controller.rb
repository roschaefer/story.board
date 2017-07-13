class SensorReadingsController < ApplicationController

  def create
    @sensor_reading = Sensor::Reading.new(sensor_reading_params)
    respond_to do |format|
      if @sensor_reading.sensor && @sensor_reading.sensor.calibrating
        @sensor_reading.sensor.calibrate(@sensor_reading)
        format.json { render json: @sensor_reading, status: :accepted }
      else
        if @sensor_reading.save
          format.json { render json: @sensor_reading, status: :created, location: @sensor_reading }
        else
          format.json { render json: @sensor_reading.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def fake
    @sensor_readings = []
    success = false
    Sensor::Reading.transaction do
      if sample_params[:from].nil? || sample_params[:to].nil?
        raise ActiveRecord::Rollback
      end
      quantity = sample_params[:quantity].to_i
      from = sample_params[:from].to_i
      to = sample_params[:to].to_i
      range = Range.new(from, to)
      @sensor_readings = (1..quantity).collect do
        params = {
          sensor_id: sample_params[:sensor_id],
          calibrated_value: rand(range),
          uncalibrated_value: rand(range),
          intention: :fake
        }
        Sensor::Reading.new(params)
      end
      success = @sensor_readings.all?(&:save)
    end
    respond_to do |format|
      if success
        format.js { render 'sensor/readings/fake' }
        format.json { render json: @sensor_readings, status: :created }
      else
        format.json { render json: @sensor_readings.map(&:errors), status: :unprocessable_entity }
      end
    end
  end

  def add
    if manual_params[:sensor_id].nil? || manual_params[:report_id].nil?
      respond_to do |format|
        format.html { redirect_to  root_path }
        format.js  { render :js => "window.location.href='"+root_path+"'"}
      end
      return
    end

    if manual_params[:timestamp].nil? || manual_params[:calibrated_value].nil? || manual_params[:uncalibrated_value].nil?
      respond_to do |format|
        format.html { redirect_to  report_sensor_path(:report_id => manual_params[:report_id] , :id => manual_params[:sensor_id]), notice: reading }
        format.js  { render :js => "window.location.href='"+report_sensor_path(:report_id => manual_params[:report_id] , :id => manual_params[:sensor_id])+"'"}
      end
      return
    end

    reading = Sensor::Reading.new(
      sensor_id: manual_params[:sensor_id],
      smaxtec_timestamp: nil,
      created_at: manual_params[:timestamp],
      updated_at: manual_params[:timestamp],
      calibrated_value: manual_params[:calibrated_value],
      uncalibrated_value: manual_params[:uncalibrated_value]
      )

    if reading.save
      respond_to do |format|
        format.html { redirect_to  report_sensor_path(:report_id => manual_params[:report_id] , :id => manual_params[:sensor_id]), notice: 'Sensor Reading was successfully created.' }
        format.js  { render :js => "window.location.href='"+report_sensor_path(:report_id => manual_params[:report_id] , :id => manual_params[:sensor_id])+"'", notice: 'Sensor Reading was successfully created.'}
      end
    else
      respond_to do |format|
        format.html { redirect_to  report_sensor_path(:report_id => manual_params[:report_id] , :id => manual_params[:sensor_id]), notice: reading }
        format.js  { render :js => "window.location.href='"+report_sensor_path(:report_id => manual_params[:report_id] , :id => manual_params[:sensor_id])+"'"}
      end
    end
  end

  private

  def manual_params
    params.require(:sensor_reading).permit(:report_id, :sensor_id, :sensor_name, :calibrated_value, :uncalibrated_value, :timestamp)
  end

  def sample_params
    params.require(:sample).permit(:sensor_id, :quantity, :from, :to)
  end

  def sensor_reading_params
    format_particle_api_json
    assign_sensor_id
    params.require(:sensor_reading).permit(:sensor_id, :sensor_name, :calibrated_value, :uncalibrated_value)
  end

  # Tries to assign a missing sensor id
  def assign_sensor_id
    sensor_params = params.permit(sensor: [:name, :address])
    if sensor_params
      dummy_sensor = Sensor.new(sensor_params[:sensor]) # perform normalization
      search_params = dummy_sensor.attributes.reject{|k,v| v.nil?}
      if search_params.present?
        params[:sensor_reading][:sensor_id] = Sensor.find_by(search_params).try(:id)
      end
    end
  end

  # Tries to assign a missing sensor id
  def format_particle_api_json
    params.permit(:published_at, :core_id, :event, :data)
    if params[:data]
      params[:sensor_reading] = JSON.parse(params[:data])
      params[:sensor] = params[:sensor_reading][:sensor]
    end
  end
end
