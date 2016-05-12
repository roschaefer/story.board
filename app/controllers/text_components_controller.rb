class TextComponentsController < ApplicationController
  def index
    @text_components = TextComponent.all
  end

  def new
  end

  def show
    @text_component = TextComponent.find(params[:id])
  end

  def create
    @text_component = TextComponent.new(text_component_params)
    @text_component.save
    redirect_to @text_component
  end


  private

  def text_component_params
    params.require(:text_component).permit(:heading, :introduction, :main_part, :closing)
  end
end
