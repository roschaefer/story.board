class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :start, :stop]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  def start
    start_or_stop(:start)
  end

  def stop
    start_or_stop(:stop)
  end


  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to events_path, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:name)
  end

  def start_or_stop(action)
    past_tense = if action.to_s.end_with?('p')
                   "#{action}ped"
                 else
                   "#{action}ed"
                 end
    respond_to do |format|
      if @event.send(action)
        format.html { redirect_to edit_event_path(@event), notice: "Event was successfully #{past_tense}." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { redirect_to edit_event_path(@event) }
        format.json { render json: { error: "Event was already #{past_tense}" }, status: :unprocessable_entity }
      end
    end
  end
end
