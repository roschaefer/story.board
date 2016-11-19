class SensorsController < ApplicationController
  before_action :set_sensor, only: [:show, :edit, :update, :destroy, :start_calibration, :stop_calibration]
  def index
    @sensors = Sensor.all
  end

  def new
    @sensor = Sensor.new
  end

  def show
    @real_readings = @sensor.sensor_readings.real.order(:created_at).last(50).reverse
    @fake_readings = @sensor.sensor_readings.fake.order(:created_at).last(50).reverse
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
    @sensor.max_value = nil
    @sensor.min_value = nil
    @sensor.calibrating = true
    @sensor.save!
    redirect_to 'show'
  end

  def stop_calibration
    @sensor.calibrating = false
    @sensor.calibrated_at = Time.now
    @sensor.save!
    redirect_to 'show'
  end

  private
  def set_sensor
    @sensor = Sensor.find(params[:id])
  end

  def sensor_params
    params.require(:sensor).permit(:name, :address, :sensor_type_id, :report_id, :unit)
  end
end
