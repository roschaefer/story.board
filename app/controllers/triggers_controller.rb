class TriggersController < ApplicationController
  def index
    @triggers = Trigger.all
  end

  def new
    @trigger = Trigger.new
  end

  def show
    @trigger = Trigger.find(params[:id])
  end

  def edit
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
    params.require(:trigger).permit(:heading, :introduction, :main_part,
                                           :closing, :priority, :report_id,
                                           :timeliness_constraint,
                                           :event_ids => [],
                                           conditions_attributes: [:id, :sensor_id, :from, :to, :_destroy])
  end
end
