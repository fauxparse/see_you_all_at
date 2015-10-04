class CreateEvent
  attr_reader :user, :event

  delegate :errors, to: :event

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    @event = Event.new(@params)
    power.creatable_event!(@event)

    Event.transaction do
      @event.administrators.build(user: @user) if user.present?
      @event.save!
    end
  end

  private

  def power
    @power ||= Power.new(@user)
  end
end
