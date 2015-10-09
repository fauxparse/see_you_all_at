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
      build_administrator if user.present?
      build_default_package
      build_default_activity_type
      @event.save!
    end
  end

  private

  def power
    @power ||= Power.new(@user)
  end

  def build_administrator
    @event.administrators.build(user: @user)
  end

  def build_default_package
    @event.packages.build(
      name: I18n.t("packages.new.default"),
      position: 0
    )
  end

  def build_default_activity_type
    @event.activity_types.build(
      name: I18n.t("activity_types.new.default"),
      position: 0
    )
  end
end
