# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out',
        'An authorized user can log out to log out' do
  given(:user) { create(:user) }

  background do
    sign_in(user)
  end

  scenario 'Authenticated user try sign out' do
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
