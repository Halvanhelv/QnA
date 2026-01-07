# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in', " analog of describe
In order to ask questions
As an unauthenticated user
I'd like to be able to sign in
" do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Register user tries to sign in' do # analog of it in unit tests
    find('input[type="email"]').set(user.email)
    find('input[type="password"]').set(user.password)
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'Unregistered user tries to sign in' do
    find('input[type="email"]').set('wrong@test.com')
    find('input[type="password"]').set('123456')
    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end
end
