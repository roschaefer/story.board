class EventDecorator

  def initialize(event)
    @event = event
  end

  def date
    date = @event.happened_at
    unless date.nil?
      date.in_time_zone(Report::TIME_ZONE).strftime(Report::DATE_FORMAT)
    else
      "NaN"
    end
  end

  def method_missing(m, *args, &block)
    @event.send(m, *args, &block)
  end
end
