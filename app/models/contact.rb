class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message, validate: true
  attribute :nickname, captcha: true

  def headers
    { subject: 'Contact Form',
      to: ENV['CONTACT_FORM_EMAIL'],
      from: address }
  end

  def address
    new_address = Mail::Address.new email
    new_address.display_name = name

    new_address
  end
end
