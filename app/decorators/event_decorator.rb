class EventDecorator

  def initialize(event)
    @event = event
  end

  def last_started_date_before(moment)
    date = @event.activations.before(moment).first&.started_at
    if date
      date.strftime(Report::DATE_FORMAT)
    else
      "(Sorry, leider habe ich gerade keine Daten für dich!)"
    end
  end


  def method_missing(m, *args, &block)
    @event.send(m, *args, &block)
  end
end
