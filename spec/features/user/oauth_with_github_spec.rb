require 'rails_helper'

feature 'User can sign in with GitHub authorization', %q(
  "In order to ask questions as an unauthenticated user
   I'd like to able to sign in"
) do
  %w[ GitHub].each do |network|

  let(:user) { create(:user) }
  background do
    visit new_user_session_path
    clean_mock_auth(network)
  end

  describe 'Registered user' do
    scenario 'try to sign in' do
      mock_auth_hash(network.to_s.downcase, email: 'test@mail.ru')
      click_on "Sign in with #{network.to_s}"
      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario 'try to sign in with failure' do
      failure_mock_auth(network.to_s.downcase)
      click_on "Sign in with #{network.to_s}"
      expect(page).to have_content "Could not authenticate you from #{network.to_s} because \"Invalid credentials\"."
    end
  end

  describe 'Unregistered user' do
    context "#{network.to_s} return email" do
      scenario 'try to sign in' do
        mock_auth_hash(network.to_s.downcase, email: 'test@mail.ru')
        click_on "Sign in with #{network.to_s}"
        save_and_open_page
        expect(page).to have_content "Successfully authenticated from #{network.to_s} account."
      end
    end
    context "#{network.to_s} not return email" do

      it 'user type email yourself' do
        mock_auth_hash(network.to_s.downcase, email: nil)
        click_on "Sign in with #{network.to_s}"
        expect(page).to have_content "Провайдер #{network.to_s.downcase} не предоставил почту"
        fill_in 'Email', with: 'test@gmail.com'
        click_on 'Send'
        expect(page).to have_content 'You have to confirm your email address before continuing.'
      end
      it 'user confirmed account' do
        mock_auth_hash(network.to_s.downcase, email: nil)
        click_on "Sign in with #{network.to_s}"
        expect(page).to have_content "Провайдер #{network.to_s.downcase} не предоставил почту"
        fill_in 'Email', with: 'test@gmail.com'
        click_on 'Send'
        open_email('test@gmail.com')
        current_email.click_link 'Confirm my account'
        expect(page).to have_content 'Your email address has been successfully confirmed'
      end
      it 'user try type exist email' do
        mock_auth_hash(network.to_s.downcase, email: nil)
        click_on "Sign in with #{network.to_s}"
        expect(page).to have_content "Провайдер #{network.to_s.downcase} не предоставил почту"
        fill_in 'Email', with: user.email
        click_on 'Send'
        expect(page).to have_content 'Email has already been taken'
      end
    end
  end
  end
end
