module EventsHelper
  def event_icon event
    case event.kind
    when Event::Kind::CALL
      :phone
    when Event::Kind::EMAIL
      :envelope
    when Event::Kind::MEETING
      :users
    else
      :glass
    end
  end

  def d dt
    dt.strftime '%d.%m.%Y'
  end

  def t dt
    dt.strftime '%H:%M'
  end

  def now
    Time.now
  end

  def event_classes event
    case
    when event.closed?
      :closed
    when event.due?
      :due
    when event.overdue?
      :overdue
    else
      ''
    end
  end
end
