module FeatureHelper
  def given_a_vistor_is_viewing_a(resource, arg)
    return unless (path_prefix = resource.to_s)

    if arg == :index
      arg = nil
      path_prefix = path_prefix.pluralize
    end

    path = path_prefix + '_path'

    visit send(path, arg)
    sleep(1)
  end

  def authenticate(user)
    visit new_user_session_path

    fill_in_login_form(user)

    click_button 'Sign in'
  end

  def fill_in_login_form(user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
  end

  def expect_forbidden_error_page
    expected_text = ['Forbidden',
                  '403',
                  'You do not have permission to view this page.']

    expected_text.each { |str| expect(page).to have_text(str) }
  end

  def get_notification_text
    find(notification_count_label).text
  end

  def notification_count_label
    '.notifications .floating.label'
  end

  def expect_redirect_to_user_page(user)
    actual = (current_path == user_path(user))
    expect(actual).to eq true
  end

  def sign_out
    find('.footer .dropdown.item').trigger('click')
    click_link('Sign Out')
  end
end
