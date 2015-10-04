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
    @event = Event.new(event_params)
    current_power.creatable_event!(@event)

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event) }
        format.json { render(json: @event) }
      else
        format.html { render(action: "new") }
        format.json do
          render(json: @event.errors, status: :unprocessable_entity)
        end
      end
    end
  end

  private

  def event_params
    params.require(:event).permit(*current_power.assignable_event_fields)
  end

  def load_event
    @event ||= events.find_by(slug: params[:id])
  end
end
