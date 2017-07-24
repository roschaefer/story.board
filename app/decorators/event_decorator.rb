class EventDecorator

  def initialize(event)
    @event = event
  end

  def date(fallback = nil)
    date = @event.happened_at
    
    if date
      date.in_time_zone(Report::TIME_ZONE).strftime(Report::DATE_FORMAT)
    elsif fallback
      fallback
    else
      "-- missing event data --"
    end
  end

  def method_missing(m, *args, &block)
    @event.send(m, *args, &block)
  end
end
