# frozen_string_literal: true

require 'rails_helper'
feature 'User can show questions', "
To see all the questions
As an Unauthenticated user
I would like to be able to select a question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario ' Authenticated user try show a questions' do
    sign_in(user)
    visit questions_path
    expect(page).to have_content 'MyString'
  end
  scenario ' Unauthenticated user try show a questions' do
    visit questions_path
    expect(page).to have_content 'MyString'
  end
  scenario 'user try show a question' do
    visit questions_path
    click_on 'MyString'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
  end
end
