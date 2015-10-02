class Power
  include Consul::Power

  def initialize(user)
    @user = user
  end

  power :users do
    User.where(id: @user.id)
  end

  power(:creatable_users) { nil }
  power(:updatable_users) { users }
  power(:destroyable_users) { nil }
end
