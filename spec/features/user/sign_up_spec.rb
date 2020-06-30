# frozen_string_literal: true

require 'rails_helper'

feature 'User can register',
        "In order to be able to log in
I would like to be able to register" do

  scenario 'User try sign_up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@gmail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User try sign_up with empty password' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@gmail.com'
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_on 'Sign up'
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'User try sign_up with empty password' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@gmail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456A'
    click_on 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'User try sign_up with empty password' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@gmail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456A'
    click_on 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
