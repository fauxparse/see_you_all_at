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
end
