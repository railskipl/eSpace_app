require 'rails_helper'

# When a new visitor comes he wants to sign up
# so that he can use the site
RSpec.feature "Sign up", type: :feature, js: true do
  scenario 'happy path' do
    visit root_path
    expect(page).to have_content('dinobo')

    fill_in 'email', with: 'john.doe@usc.edu'
    click_on 'Sign Up'
  end
end
