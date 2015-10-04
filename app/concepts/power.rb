class Power
  include Consul::Power

  def initialize(user)
    @user = user
  end

  power :users do
    @user.admin? && User || User.where(id: @user.id)
  end

  power(:creatable_users) do
    @user.admin? && User || nil
  end

  power(:updatable_users) { users }
  power(:destroyable_users) { nil }

  power :events do
    Event
  end

  power(:creatable_events) { @user.presence && events }
  power(:updatable_events) { events }
  power(:destroyable_events) { events }

  power :assignable_event_fields do
    [:name, :slug, :starts_on, :ends_on]
  end
end
