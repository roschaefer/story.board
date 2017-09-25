class TextComponentDecorator

  def initialize(text_component, diary_entry)
    @diary_entry = diary_entry
    @renderer = Text::Renderer.new(text_component: text_component, diary_entry: @diary_entry)
    @text_component = text_component
  end

  [:heading, :introduction, :main_part, :closing].each do |part|
    define_method(part) do
      @renderer.render(part) 
    end
  end

  def table_highlight_class
    if @text_component.active?(@diary_entry)
      if @text_component.published?
        'item-table__item--success'
      else
        'item-table__item--highlight'
      end
    end
  end

  def table_status_text
    "#{channel_list} / #{publication_status.humanize}"
  end

  def table_channel_icon
    if(channel_icons.length > 1)
      'fa-ellipsis-h'
    else
      channel_icons.first
    end
  end

  def status_class
    # These class modifiers really aren't semantic
    # and should be changed in the future

    status_css_class_mapping = {
      'draft' => 'primary',
      'fact_checked' => 'warning',
      'published' => 'success'
    }

    if status_css_class_mapping.key? publication_status
      status_css_class_mapping[publication_status]
    else
      'default'
    end
  end

  def channel_list
    @text_component.channels.map{|c| c.name.humanize}.join(', ')
  end

  def channel_icons
    channel_icon_mapping = {
      'sensorstory' => 'fa-file-text',
      'chatbot' => 'fa-comment'
    }

    icons = []

    channels.each do |channel|
      icons.push(channel_icon_mapping[channel.name])
    end

    icons.compact
  end

  def to_param
    @text_component.to_param
  end

  def method_missing(m, *args, &block)
    @text_component.send(m, *args, &block)
  end
end
