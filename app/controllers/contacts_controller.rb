class ContactsController < ApplicationController
  before_action { load_html_title('contact') }

  def new
    @model = Contact.new
    set_new_variabes
    load_html_description(contact_description)
  end

  def create
    @model = Contact.new(params[:contact])
    @model.request = request

    if @model.deliver
    else
      flash.now[:error] = 'Cannot send message'
      set_new_variabes
      render :new
    end

    load_html_description(contact_description)
  end

  private
  def set_new_variabes
    @title = "Contact #{@app_name} Today"
    @contact_email = ENV['CONTACT_FORM_EMAIL']
  end

  def contact_description
    "You may contact #{@app_name} by fill out the contact form, sending an email, or reaching out on social media."
  end
end
