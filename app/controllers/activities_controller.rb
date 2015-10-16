class ActivitiesController < ApplicationController
  before_action :load_event
  before_action :load_activity_type
  before_action :load_activity, only: [:show, :edit, :update, :destroy]

  private

  def load_activity_type
    @activity_type ||= params[:type] &&
                       @event.activity_types.find_by(slug: params[:type]) ||
                       @event.activity_types.first
  end

  def activity_scope
    @activity_type.activities
  end

  def load_activity
    @activity ||= activity_scope.find_by!(slug: params[:id])
  end
end
