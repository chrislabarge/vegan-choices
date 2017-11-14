module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    html = (render 'shared/messages', type: 'error', messages: resource.errors.messages)

    html.html_safe
  end

  def devise_error_messages?
    return unless defined?(resource)
    !resource.errors.empty?
  end

  def devise_alert
    messages = resource.errors.messages
    I18n.t("errors.messages.not_saved",
      :count => resource.errors.count,
      :resource => resource.class.model_name.human.downcase)
  end
end
