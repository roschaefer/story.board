class TextComponentDecorator

  def initialize(text_component, diary_entry)
    @renderer = Text::Renderer.new(text_component: text_component, diary_entry: diary_entry)
    @text_component = text_component
  end

  [:heading, :introduction, :main_part, :closing].each do |part|
    define_method(part) do
      @renderer.render(part) 
    end
  end

  def to_param
    @text_component.to_param
  end

  def method_missing(m, *args, &block)
    @text_component.send(m, *args, &block)
  end
end
