require 'rails_helper'

feature 'User can sign in with GitHub authorization', %q(
  "In order to ask questions as an unauthenticated user
   I'd like to able to sign in"
) do
  %w[GitHub Telegram].each do |network|
    let(:user) { create(:user) }
    background do
      visit new_user_session_path
      clean_mock_auth(network)
    end

    describe 'Registered user' do
      scenario 'try to sign in' do
        mock_auth_hash(network.downcase, email: 'test@mail.ru')
        click_on "Sign in with #{network}"
        expect(page).to have_content "Successfully authenticated from #{network.capitalize} account."
      end

      scenario 'try to sign in with failure' do
        failure_mock_auth(network.downcase)
        click_on "Sign in with #{network}"
        expect(page).to have_content "Could not authenticate you from #{network} because \"Invalid credentials\"."
      end
    end

    describe 'Unregistered user' do
      context "#{network} return email" do
        scenario 'try to sign in' do
          mock_auth_hash(network.downcase, email: 'test@mail.ru')
          click_on "Sign in with #{network}"
          expect(page).to have_content "Successfully authenticated from #{network.capitalize} account."
        end
      end
      context "#{network} not return email" do
        it 'user type email yourself' do
          mock_auth_hash(network.downcase, email: nil)
          click_on "Sign in with #{network}"
          expect(page).to have_content I18n.t('oauth.email_blank', provider: network.downcase)
          fill_in 'Email', with: 'test@gmail.com'
          click_on 'Send'
          expect(page).to have_content 'You have to confirm your email address before continuing.'
        end
        it 'user confirmed account' do
          mock_auth_hash(network.downcase, email: nil)
          click_on "Sign in with #{network}"
          expect(page).to have_content I18n.t('oauth.email_blank', provider: network.downcase)
          fill_in 'Email', with: 'test@gmail.com'
          click_on 'Send'
          open_email('test@gmail.com')
          current_email.click_link 'Confirm my account'
          expect(page).to have_content 'Your email address has been successfully confirmed'
        end
        it 'user try type exist email' do
          mock_auth_hash(network.downcase, email: nil)
          click_on "Sign in with #{network}"
          expect(page).to have_content I18n.t('oauth.email_blank', provider: network.downcase)
          fill_in 'Email', with: user.email
          click_on I18n.t('oauth.email.send')
          expect(page).to have_content 'Email has already been taken'
        end
      end
    end
  end
end
