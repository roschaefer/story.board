class EventDecorator

  def initialize(event)
    @event = event
  end

  def date
    date = @event.happened_at
    date.in_time_zone('Europe/Berlin').strftime('%-d.%-m.%Y')
  end

  def method_missing(m, *args, &block)
    @event.send(m, *args, &block)
  end
end
