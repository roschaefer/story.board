class TextComponentsController < ApplicationController
  before_action :set_text_component, only: [:show, :edit, :update, :destroy]

  # GET /text_components
  # GET /text_components.json
  def index
    text_components = TextComponent.left_joins(:triggers)
    @triggers = text_components.map{|t| t.triggers}.flatten.uniq
    @remaining_text_components = text_components.select{|t| t.triggers.empty?}
  end

  # GET /text_components/1
  # GET /text_components/1.json
  def show
  end

  # GET /text_components/new
  def new
    @report_id = Report.current_report_id
    @text_component = TextComponent.new
  end

  # GET /text_components/1/edit
  def edit
    @report_id = Report.current_report_id
  end

  # POST /text_components
  # POST /text_components.json
  def create
    @text_component = TextComponent.new(text_component_params)

    respond_to do |format|
      if @text_component.save
        format.html { redirect_to @text_component, notice: 'Text component was successfully created.' }
        format.json { render :show, status: :created, location: @text_component }
      else
        format.html { render :new }
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
        format.html { render :edit }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def text_component_params
      params.require(:text_component).permit(:heading, :introduction,
                                             :main_part, :closing, :from_day,
                                             :to_day, :report_id, trigger_ids: [])
    end
end
