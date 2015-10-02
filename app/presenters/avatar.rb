require "digest/md5"

class Avatar
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include Rails.application.routes.url_helpers

  attr_reader :user, :options

  def initialize(user, options = {})
    @user = user
    @options = options.reverse_merge!(default_options)
  end

  def to_html
    link_to_unless(path == false, inner_html, path, class: "avatar")
  end

  private

  def inner_html
    [
      image,
      (name unless options[:name] == false)
    ].compact.join.html_safe
  end

  def name
    content_tag(:span, user.name, class: "name")
  end

  def image
    image_tag(image_url)
  end

  def image_url
    @image_url ||= user.avatar || gravatar_url
  end

  def gravatar_url
    hash = Digest::MD5.hexdigest(user.email.strip.downcase)
    "http://www.gravatar.com/avatar/#{hash}"
  end

  def path
    options[:link]
  end

  def default_options
    { link: user_path(user) }
  end

  # Needed for link_to for some reason
  def controller
    nil
  end
end
