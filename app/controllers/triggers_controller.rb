class TriggersController < ApplicationController
  def index
    @triggers = Trigger.all
  end

  def new
    @report_id = Report.current_report_id
    @trigger = Trigger.new
  end

  def show
    @trigger = Trigger.find(params[:id])
  end

  def edit
    @report_id = Report.current_report_id
    @trigger = Trigger.find(params[:id])
  end

  def create
    @trigger = Trigger.new(trigger_params)
    if @trigger.save
      redirect_to @trigger
    else
      render 'new'
    end
  end

  def update
    @trigger = Trigger.find(params[:id])
    if @trigger.update(trigger_params)
      redirect_to @trigger
    else
      render 'new'
    end
  end

  def destroy
    @trigger = Trigger.find(params[:id])
    @trigger.destroy

    redirect_to triggers_path
  end

  private

  def trigger_params
    params.require(:trigger).permit(:heading, :name,
                                    :priority, :report_id,
                                    :timeliness_constraint,
                                    :event_ids => [],
                                    conditions_attributes: [:id, :sensor_id, :from, :to, :_destroy])
  end
end
