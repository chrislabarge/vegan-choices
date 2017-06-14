class ContactsController < ApplicationController
  def new
    @model = Contact.new
    set_new_variabes
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
  end

  def set_new_variabes
    @title = 'Contact Us Today'
    @contact_email = ENV['CONTACT_FORM_EMAIL']
  end
end
