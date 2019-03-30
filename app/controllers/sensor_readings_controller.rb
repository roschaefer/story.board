# frozen_string_literal: true

class SensorReadingsController < ApplicationController
  include CommonFilters
  before_action :set_sensor
  before_action :authenticate_user!, except: %i[index create debug destroy]

  def index
    from_and_to_params_are_dates(filter_params) || return
    @sensor_readings = @sensor.sensor_readings.order(created_at: :desc)
    @sensor_readings = filter_release(@sensor_readings, filter_params)
    @sensor_readings = filter_timestamp(@sensor_readings, filter_params)
    @sensor_readings
  end

  def update
    @sensor_reading = Sensor::Reading.find(sensor_reading_delete_params['sensor_reading_id'])
    respond_to do |format|
      if @sensor_reading.update(sensor_reading_params)
        sensor = @sensor_reading.sensor
        report = sensor.report
        format.html { redirect_to report_sensor_path(report, sensor), notice: 'Sensor reading was successfully updated.' }
        format.json { render :show, status: :accepted, location: report_sensor_reading_url(@report, @sensor_reading) }
      else
        format.html do
          flash[:error] = 'There was an error updating the sensor reading!'
          redirect_to report_sensor_path(report, sensor)
        end
        format.json { render json: @sensor_reading.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @sensor_reading = Sensor::Reading.new(sensor_reading_params)
    @sensor_reading.sensor = @sensor
    respond_to do |format|
      if @sensor_reading.sensor&.calibrating
        @sensor_reading.sensor.calibrate(@sensor_reading)
        format.json { render json: @sensor_reading, status: :accepted }
      else
        if @sensor_reading.save
          format.js { render 'sensor/readings/create' }
          format.json { render :show, status: :created, location: report_sensor_reading_url(@report, @sensor, @sensor_reading) }
        else
          format.json { render json: @sensor_reading.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def debug
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
          sensor: @sensor,
          calibrated_value: rand(range),
          uncalibrated_value: rand(range),
          release: :debug
        }
        Sensor::Reading.new(params)
      end
      success = @sensor_readings.all?(&:save)
    end
    respond_to do |format|
      if success
        format.js { render 'sensor/readings/debug' }
        format.json { render json: @sensor_readings, status: :created }
      else
        format.json { render json: @sensor_readings.map(&:errors), status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sensor_reading = Sensor::Reading.find(sensor_reading_delete_params['sensor_reading_id'])
    if @sensor_reading.destroy
      respond_to do |format|
        format.js { render 'sensor/readings/destroy' }
        format.json { render :index, status: 200, location: report_sensor_readings_url(@report, @sensor) }
      end
    end
  end

  private

  def set_sensor
    if sensor_params.empty?
      @sensor = Sensor.find(params[:id])
    else
      # Override
      dummy_sensor = Sensor.new(sensor_params[:sensor]) # perform normalization
      search_params = dummy_sensor.attributes.reject { |_k, v| v.nil? }
      @sensor = Sensor.find_by(search_params) if search_params.present?
    end
  end

  def sample_params
    params.require(:sample).permit(:sensor_id, :quantity, :from, :to)
  end

  def sensor_reading_params
    format_particle_api_json
    params.require(:sensor_reading).permit(:calibrated_value, :uncalibrated_value, :created_at, :id, :annotation)
  end

  def sensor_reading_delete_params
    params.permit(:sensor_reading_id, :report_id, :sensor_id)
  end

  def sensor_params
    format_particle_api_json
    sensor_params = params.permit(sensor: %i[name address])
  end

  # Tries to parse "data" (the only way to send attributes via partical API)
  def format_particle_api_json
    params.permit(:published_at, :core_id, :event, :data)
    if params[:data]
      begin
      params[:sensor_reading] = JSON.parse(params[:data])
      rescue JSON::ParserError
        head :bad_request
      end
      params[:sensor] = params[:sensor_reading][:sensor]
    end
  end

  def filter_params
    params.permit(:from, :to, :release)
  end
end
