module UsersHelper
  def avatar(user = current_user, options = {})
    Avatar.new(user, options).to_html
  end
end
