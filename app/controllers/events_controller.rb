class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_event, only: [:show, :edit, :update, :destroy]

  wrap_parameters :event, include: [:name, :packages, :activity_types]

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
    create_or_update_event(CreateEvent.new(current_user, event_params))
  end

  def edit
    current_power.updatable_event!(@event)
  end

  def update
    current_power.updatable_event!(@event)
    create_or_update_event(UpdateEvent.new(@event, event_params))
  end

  private

  def event_params
    params.require(:event)
      .permit(*current_power.assignable_event_fields, package_limit_fields)
  end

  def package_limit_fields
    packages = params[:event] && params[:event][:packages]
    return {} unless packages.present?

    activity_type_ids = packages.values.inject([]) do |ids, pkg|
      ids | pkg[:limits].keys
    end

    { packages: [:id, :name, :position, { limits: activity_type_ids }] }
  end

  def load_event
    @event ||= events.find_by!(slug: params[:id])
  end

  def create_or_update_event(service)
    service.call
    respond_with_success(service)
  rescue ActiveRecord::RecordInvalid
    respond_with_failure(service)
  end

  def respond_with_success(service)
    respond_to do |format|
      format.html { redirect_to(edit_event_path(service.event)) }
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
