require 'rails_helper'

feature 'User can sign in with GitHub authorization', %q(
  "In order to ask questions as an unauthenticated user
   I'd like to able to sign in"
) do
  background do
    visit new_user_session_path
    clean_mock_auth('github')
  end
  describe 'Registered user' do
    scenario 'try to sign in' do
      mock_auth_hash('github', email: 'test@mail.ru')
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario 'try to sign in with failure' do
      failure_mock_auth('github')
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials".'
    end
  end

  describe 'Unregistered user' do
    context 'Github return email' do
      scenario 'try to sign in' do
        mock_auth_hash('github', email: 'test@mail.ru')
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end
    context 'Github not return email' do
      it 'user type email yourself' do
        mock_auth_hash('github', email: nil)
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Провайдер github не предоставил почту'
        fill_in 'Email', with: 'test@gmail.com'
        click_on 'Send'
        expect(page).to have_content 'You have to confirm your email address before continuing.'
      end
      it 'user confirmed account' do
        mock_auth_hash('github', email: nil)
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Провайдер github не предоставил почту'
        fill_in 'Email', with: 'test@gmail.com'
        click_on 'Send'
        open_email('test@gmail.com')
        current_email.click_link 'Confirm my account'
        expect(page).to have_content 'Your email address has been successfully confirmed'
      end
    end
  end
end
