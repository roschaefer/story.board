class TextComponentsController < ApplicationController
  def index
    @text_components = TextComponent.all
  end

  def new
    @text_component = TextComponent.new
  end

  def show
    @text_component = TextComponent.find(params[:id])
  end

  def edit
    @text_component = TextComponent.find(params[:id])
  end

  def create
    @text_component = TextComponent.new(text_component_params)
    if @text_component.save
      redirect_to @text_component
    else
      render 'new'
    end
  end

  def update
    @text_component = TextComponent.find(params[:id])
    if @text_component.update(text_component_params)
      redirect_to @text_component
    else
      render 'new'
    end
  end

  def destroy
    @text_component = TextComponent.find(params[:id])
    @text_component.destroy

    redirect_to text_components_path

  end


  private

  def text_component_params
    params.require(:text_component).permit(:heading, :introduction, :main_part, :closing)
  end
end
