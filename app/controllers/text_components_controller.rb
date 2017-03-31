class TextComponentsController < ApplicationController
  before_action :set_text_component, only: [:show, :update, :destroy]

  # GET /text_components
  # GET /text_components.json
  def index
    set_triggers_and_text_components
    @text_component = @new_text_component
  end

  # GET /text_components/1
  # GET /text_components/1.json
  def show
  end

  # POST /text_components
  # POST /text_components.json
  def create
    @text_component = TextComponent.new(text_component_params)

    @text_component.triggers.each do |trigger|
      if trigger.report.nil?
        trigger.report = @text_component.report
      end
      trigger.conditions.each {|c| c.trigger = trigger } # both trigger and condition are new and need to be connected
    end

    respond_to do |format|
      if @text_component.save
        format.html { redirect_to @text_component, notice: 'Text component was successfully created.' }
        format.json { render :show, status: :created, location: @text_component }
      else
        format.html do
          set_triggers_and_text_components
          render :index
        end
        format.json { render json: @text_component.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /text_components/1
  # PATCH/PUT /text_components/1.json
  def update
    respond_to do |format|
      if @text_component.update(text_component_params)
        format.html { redirect_to @text_component, notice: 'Text component was successfully updated.' }
        format.json { render :show, status: :ok, location: @text_component }
      else
        format.html do
          set_triggers_and_text_components
          render :index
        end
        format.json { render json: @text_component.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /text_components/1
  # DELETE /text_components/1.json
  def destroy
    @text_component.destroy
    respond_to do |format|
      format.html { redirect_to text_components_url, notice: 'Text component was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_text_component
      @text_component = TextComponent.find(params[:id])
    end

    def set_triggers_and_text_components
      @new_text_component = TextComponent.new
      @new_text_component.triggers.build
      @new_text_component.report = Report.current
      @triggers = Trigger.includes(:text_components)
      @remaining_text_components = TextComponent.left_joins(:triggers).includes(:triggers).distinct
      @remaining_text_components = @remaining_text_components.select{|t| t.triggers.empty?}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def text_component_params
      params.require(:text_component)
        .permit(:heading, :introduction, :main_part, :closing, :from_day,
                :to_day, :report_id, :topic_id, trigger_ids: [], channel_ids: [],
                question_answers_attributes: [:question, :answer],
                triggers_attributes: [:name, :from_hour, :to_hour,
                                      :priority, :report_id,
                                      :timeliness_constraint,
                                      :event_ids => [],
                                      conditions_attributes: [:id, :sensor_id, :from, :to, :_destroy]] )
    end
end
