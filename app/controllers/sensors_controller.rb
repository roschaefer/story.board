class SensorsController < ApplicationController
  def index
    @sensors = Sensor.all
  end

  def new
     @sensor= Sensor.new
  end

  def show
    @sensor = Sensor.find(params[:id])
    @readings = @sensor.sensor_readings
  end

  def edit
    @sensor = Sensor.find(params[:id])
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
    @sensor = Sensor.find(params[:id])
    if @sensor.update(sensor_params)
      redirect_to @sensor
    else
      render 'new'
    end
  end

  def destroy
    @sensor = Sensor.find(params[:id])
    @sensor.destroy
    redirect_to sensors_path
  end


  private

  def sensor_params
    params.require(:sensor).permit(:name, :address, :sensor_type_id, :report_id, :unit)
  end
end
