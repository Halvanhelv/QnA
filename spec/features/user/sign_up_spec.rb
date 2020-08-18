# frozen_string_literal: true

require 'rails_helper'

feature 'User can register',
        "In order to be able to log in
I would like to be able to register" do
  describe 'User try sign_up with ' do
    scenario 'correct data' do
      visit new_user_registration_path
      fill_in 'Email', with: 'test@gmail.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'
      open_email('test@gmail.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'empty password' do
      visit new_user_registration_path
      fill_in 'Email', with: 'test@gmail.com'
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      click_on 'Sign up'
      expect(page).to have_content "Password can't be blank"
    end

    scenario 'wrong password' do
      visit new_user_registration_path
      fill_in 'Email', with: 'test@gmail.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456A'
      click_on 'Sign up'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end
