module NotificationResource
  extend ActiveSupport::Concern

  def remove_notifications
    Notification.where(resource: self.class.name.underscore.to_sym, resource_id: self.id).each(&:destroy)
  end

  def notify_user(user)
    generator = NotificationGenerator.new(self, user: user)

    generator.generate
  end

  def notify_users(users, resource)
    generator = NotificationGenerator.new(self, users: users, resource: resource)

    generator.generate
  end
end
