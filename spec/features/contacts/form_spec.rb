require 'rails_helper'

feature 'Contacts Form', js: true do
  scenario 'Succusessfully submit the contact form' do
    contact = FactoryGirl.build(:contact)

    visit new_contact_path

    fill_out_contacts_form(contact)
    click_button('Send Message')

    they_should_receive_as_successful_submit_message
  end

  scenario 'Succusessfully submit a restaurant with the contact form' do
    contact = FactoryGirl.build(:contact)

    visit new_contact_path

    fill_out_contacts_form(contact)
    click_button('Yes')

    fill_in('Restaurant', with: 'A new Restaurant')

    click_button('Send Message')

    they_should_receive_as_successful_submit_message
  end

  scenario 'Unsuccusessfully submit the contact form' do
    contact = FactoryGirl.build(:contact)

    visit new_contact_path

    fill_out_contacts_form(contact)
    fill_in('Message', with: '')

    click_button('Send Message')

    they_should_receive_an_error_message
    expect(page).to have_content("Message can't be blank")
  end

  scenario 'Invalid email causes an unsuccessful form submission' do
    invalid_email = 'invalid@email'
    contact = FactoryGirl.build(:contact, email: invalid_email)

    visit new_contact_path

    fill_out_contacts_form(contact)
    fill_in('Message', with: '')

    click_button('Send Message')

    they_should_receive_an_error_message
    expect(page).to have_content("Email is invalid")
  end

  private

  def fill_out_contacts_form(contact)
    fill_in('Name', with: contact.name)
    fill_in('Email', with: contact.email)
    fill_in('Message', with: contact.message)
  end

  def they_should_receive_as_successful_submit_message
    expect(page).to have_content('Thank you for reaching out.')
    expect(page).to have_content('We will get back to you shortly.')
  end

  def they_should_receive_an_error_message
    expect(page).to have_content('Cannot send message')
  end
end
