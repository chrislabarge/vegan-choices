class UserAuthentication < ApplicationRecord
  def self.from_omniauth(auth)
    user = override_existing_user(auth)
    return user if user.present?

    User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      info = auth.info

      set_user_auth_attributes(user, info)
    end
  end

  def self.set_user_auth_attributes(user, info)
    user.email = info.email
    user.password = Devise.friendly_token[0,20]
    user.name = info.nickname
    # user.image = info.image # assuming the user model has an image
    # If you are using confirmable and the provider(s) you use validate emails,
    # uncomment the line below to skip the confirmation emails.
    # user.skip_confirmation!
    user
  end

  def self.override_existing_user(auth)
    info = auth.info
    return unless (user = User.find_by(email: info.email))

    user .provider = auth.provider
    user.uid = auth.uid
    set_user_auth_attributes(user, info)
  end
end
