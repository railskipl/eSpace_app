require 'rails_helper'

# When a new visitor comes he wants to sign up
# so that he can use the site
RSpec.feature "Sign up", type: :feature, js: true do
  background do
    AccessId.create!(email: 'usc.edu')
  end

  scenario 'happy path' do
    visit root_path

    fill_in 'email', with: 'john.doe@usc.edu'
    click_button 'Sign Up'

    expect(page).to have_content('Sign up')

    fill_in 'user_name', with: 'John'
    fill_in 'user_last_name', with: 'Doe'
    fill_in 'user_password', with: 'secret'
    fill_in 'user_password_confirmation', with: 'secret'
    find('.tasks-list-mark').click
    click_button 'Submit'

    open_email('john.doe@usc.edu')
    current_email.click_link 'Confirm my account'

    fill_in 'user_email', with: 'john.doe@usc.edu'
    fill_in 'user_password', with: 'secret'
    click_button 'Login'

    expect(page).to have_content('Signed in successfully')
  end
end
