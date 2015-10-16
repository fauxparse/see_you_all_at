module ActivityUrlHelpers
  def activity_path(activity, options = {})
    event_activity_path(activity.event, activity, options)
  end

  def activity_url(activity, options = {})
    event_activity_url(activity.event, activity, options)
  end

  def edit_activity_path(activity, options = {})
    event_edit_activity_path(*activity_path_options(activity, options))
  end

  def edit_activity_url(activity, options = {})
    event_edit_activity_url(*activity_path_options(activity, options))
  end

  def event_activity_path(event, activity, options = {})
    super(*activity_path_options(activity, options))
  end

  def event_activity_url(event, activity, options = {})
    super(*activity_path_options(activity, options))
  end

  def edit_event_activity_path(event, activity, options = {})
    event_edit_activity_path(*activity_path_options(activity, options))
  end

  def edit_event_activity_url(event, activity, options = {})
    event_edit_activity_url(*activity_path_options(activity, options))
  end

  def url_for(options = nil)
    if options.is_a?(Activity)
      event_activity_path(options.event, options)
    else
      super
    end
  end

  private

  def activity_path_options(activity, options)
    [activity.event, activity.activity_type, activity, options]
  end
end

Rails.application.routes.url_helpers.send(:include, ActivityUrlHelpers)
