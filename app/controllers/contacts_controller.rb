class ContactsController < ApplicationController
  before_action { load_html_title('contact') }

  def new
    initialize_contact
    set_new_variabes
    load_html_description(contact_description)
  end

  def create
    if create_contact && deliver_contact
      successful_creation
    else
      unsuccessful_creation
    end
  end

  private

  def initialize_contact
    @model = Contact.new
  end

  def set_new_variabes
    @title = "Contact #{@app_name} Today"
    @contact_email = ENV['CONTACT_FORM_EMAIL']
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end

  def create_contact
    return unless (@model = Contact.new(params[:contact]))
    @model.request = request
  end

  def deliver_contact
    @model.deliver
  end

  def successful_creation
    flash[:success] = 'Thank you for reaching out. We will get back to you shortly.'
    redirect_to new_contact_url
  end

  def unsuccessful_creation
    flash.now[:error] = 'Cannot send message'
    set_new_variabes
    render :new
  end

  def contact_description
    "You may contact #{@app_name} by fill out the contact form, sending an email, and/or reaching out on social media."
  end
end
