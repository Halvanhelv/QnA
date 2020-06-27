require 'rails_helper'
feature 'User can create question', "
In order to get answer from a community
As an authenticated user
I'd like to be able to ask the question
" do

  given(:user) { User.create!(email: 'user@test.com', password: '123456') }
  scenario 'Authenticated user asks a question' do
     visit new_user_session_path
     fill_in 'Email', with: user.email
     fill_in 'Password', with: user.password
     click_on 'Log in'
     visit questions_path
     click_on 'Ask question'
     fill_in 'Title', with: 'Test question'
     fill_in 'Body', with: 'text text text'
     click_on 'Ask'
     expect(page).to have_content 'Your question successfully created.'
     expect(page).to have_content 'Test question'
     expect(page).to have_content 'text text text'

  end


  scenario 'Authenticated user asks a question with errors'
  scenario 'Authenticated user tries to ask a question'
end