class SensorsController < ApplicationController
  before_action :set_sensor, only: [:show, :edit, :update, :destroy, :start_calibration, :stop_calibration]
  before_action :set_readings, only: [:show, :start_calibration, :stop_calibration]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @sensors = Sensor.all
  end

  def new
    @sensor = Sensor.new
  end

  def create
    @sensor = Sensor.new(sensor_params)
    if @sensor.save
      redirect_to @sensor
    else
      render 'new'
    end
  end

  def update
    if @sensor.update(sensor_params)
      redirect_to @sensor
    else
      render 'new'
    end
  end

  def destroy
    @sensor.destroy
    redirect_to sensors_path
  end

  def start_calibration
    @sensor.calibrating = true
    @sensor.max_value = nil
    @sensor.min_value = nil
    @sensor.save!
    render 'show'
  end

  def stop_calibration
    @sensor.calibrating = false
    @sensor.calibrated_at = Time.now
    @sensor.save!
    render 'show'
  end

  private
  def set_sensor
    @sensor = Sensor.find(params[:id])
  end

  def set_readings
    @real_readings = @sensor.sensor_readings.real.order(:created_at).last(50).reverse
    @fake_readings = @sensor.sensor_readings.fake.order(:created_at).last(50).reverse
  end

  def sensor_params
    params.require(:sensor).permit(:name, :address, :sensor_type_id, :report_id, :unit, :animal_id)
  end
end
