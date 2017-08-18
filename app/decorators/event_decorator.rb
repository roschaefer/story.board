class EventDecorator

  def initialize(event)
    @event = event
  end

  def last_started_date_before(moment)
    date = @event.activations.before(moment).first&.started_at
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
