module DefaultBerry
  extend ActiveSupport::Concern

  private

  def give_default_berry
    return unless user
    resource = self.class.name.underscore.downcase.to_sym

    ContentBerry.create(resource => self, user: user)
  end
end
