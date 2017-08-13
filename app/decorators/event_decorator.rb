class EventDecorator

  def initialize(event)
    @event = event
  end

  def date
    date = @event.last_activation_started_at
    if date
      date.in_time_zone(Report::TIME_ZONE).strftime(Report::DATE_FORMAT)
    else
      "-- missing event data --"
    end
  end

  def method_missing(m, *args, &block)
    @event.send(m, *args, &block)
  end
end
