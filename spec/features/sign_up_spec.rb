require 'rails_helper'

# When a new visitor comes he wants to sign up
# so that he can use the site
RSpec.feature "Sign up", :type => :feature do
  scenario 'happy path' do
    visit root_url
    expect(page).to have_content('dinobo')
  end
end
