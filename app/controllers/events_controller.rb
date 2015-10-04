class EventsController < ApplicationController
  before_action :load_event, only: [:show, :edit, :update, :destroy]

  require_power_check
  power :events, as: :events

  def index
  end

  def show
  end

  def new
    @event = events.new
    current_power.creatable_event!(@event)
  end

  def create
    create_event = CreateEvent.new(current_user, event_params)
    create_event.call
    respond_with_success(create_event)

  rescue ActiveRecord::RecordInvalid
    respond_with_failure(create_event)
  end

  private

  def event_params
    params.require(:event).permit(*current_power.assignable_event_fields)
  end

  def load_event
    @event ||= events.find_by(slug: params[:id])
  end

  def respond_with_success(service)
    respond_to do |format|
      format.html { redirect_to(service.event) }
      format.json { render(json: service.event) }
    end
  end

  def respond_with_failure(service)
    respond_to do |format|
      @event = service.event

      format.html { render(action: @event.new_record? ? "new" : "edit") }
      format.json { render(json: @event.errors, status: :unprocessable_entity) }
    end
  end
end
