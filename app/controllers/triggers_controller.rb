class TriggersController < ApplicationController
  before_action :set_trigger, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  def index
    @triggers = Trigger.all
  end

  def new
    @trigger = Trigger.new
    @trigger.report = Report.current
  end

  def show
  end

  def edit
  end

  def create
    @trigger = Trigger.new(trigger_params)

    respond_to do |format|
      if @trigger.save
        format.html { redirect_to report_trigger_url(@report, @trigger), notice: 'Trigger was successfully created.' }
        format.json { render :show, status: :created, location: @trigger }
      else
        format.html { render :new }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @trigger.update(trigger_params)
        format.html { redirect_to report_trigger_url(@report, @trigger), notice: 'Trigger was successfully updated.' }
        format.json { render :show, status: :ok, location: @trigger }
      else
        format.html { render :edit }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @trigger.destroy
    respond_to do |format|
      format.html { redirect_to report_triggers_url(@report), notice: 'Trigger was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_trigger
    @trigger = Trigger.find(params[:id])
  end

  def trigger_params
    params.require(:trigger).permit(:heading, :name, :from_hour, :to_hour,
                                    :priority, :report_id,
                                    :timeliness_constraint,
                                    :event_ids => [],
                                    conditions_attributes: [:id, :sensor_id, :from, :to, :_destroy])
  end
end
