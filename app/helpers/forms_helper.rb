module FormsHelper
  def inline_errors_for(instance, field)
    error_messages_for(instance, field).join
  end

  def save_button(form)
    action = form.object.new_record? ? "create" : "save"
    button_tag(t(".#{action}"), type: :submit)
  end

  private

  def error_messages_for(instance, field)
    instance.errors.full_messages_for(field).map do |msg|
      inline_error_message(msg)
    end
  end

  def inline_error_message(msg)
    content_tag(:div, msg, class: "error")
  end
end
