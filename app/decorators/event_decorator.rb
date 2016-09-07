class EventDecorator

  def initialize(event)
    @event = event
  end

  def date
    date = @event.happened_at
    date.in_time_zone(Report::TIME_ZONE).strftime(Report::DATE_FORMAT)
  end

  def method_missing(m, *args, &block)
    @event.send(m, *args, &block)
  end
end
