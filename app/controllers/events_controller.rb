class EventsController < ApplicationController
  include Projectable

  layout 'dashboard'
  helper_method :projects, :events, :persons

  def index
  end

  def create
    create_event!
    close_parent!
    redirect_to events_path
  end

  def update
    update_event!
    update_interview!
    redirect_to events_path
  end

  def destroy
    event.delete
    redirect_to events_path
  end

  private

  def event
    @event ||= events_collection.find(params[:id])
  end

  def events
    case focus
    when :today
      overdue_events + today_events
    when :next
      next_events
    when :someday
      someday_events
    else
      []
    end
  end

  def focus
    if params.key? :focus
      params.permit(:focus)[:focus].to_sym
    else
      :today
    end
  end

  def today_events
    @today_events ||= events_collection.today.order_by(closed_at: 1, planned_at: 0)
  end

  def overdue_events
    @overdue_events ||= events_collection.overdue.order_by(planned_at: 0)
  end

  def next_events
    @next_events ||= events_collection.next.order_by(planned_at: 0)
  end

  def someday_events
    @someday_events ||= events_collection.someday.order_by(planned_at: 0)
  end

  def events_collection
    Event.of(current_user)
  end

  def persons
    Person.of(current_user).accepted
  end

  def create_event!
    Event::Creator.new(current_user, new_event_params).call
  end

  def new_event_params
    params.require(:event).permit(:kind, :person, :planned_at, :note).merge!(planned_at: planned_at)
  end

  def update_event!
    event.update_attributes! event_params
  end

  def event_params
    params.require(:event).permit(:note).merge! planned_at: planned_at
  end

  def update_interview!
    event.interview = []
    interview_params[:interview].each do |item|
      event.interview << Question.new(item)
    end
    event.save!
  end

  def interview_params
    params.require(:event).permit(interview: [:question, :answer])
  end

  def close_parent!
    return unless parent_event
    parent_event.close!
    parent_event.save!
  end

  def parent_event
    return unless params[:parent_event].present?
    @parent_event ||= events_collection.find(params[:parent_event])
  end

  def planned_at
    p = params.require(:event).permit(:planned_at_date, :planned_at_time)
    DateTime.strptime("#{p[:planned_at_date]} #{p[:planned_at_time]}", '%d.%m.%Y %H:%M')
  end
end
