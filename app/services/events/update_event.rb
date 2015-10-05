class UpdateEvent
  attr_reader :event

  delegate :errors, to: :event

  def initialize(event, params)
    @event = event
    @params = params
  end

  def call
    @event.update!(@params)
  end
end
