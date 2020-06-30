# frozen_string_literal: true

require 'rails_helper'
feature 'User can create answer for question', "
To write the answer to the question as an authorized user
I would like to write an answer to the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authernticated user ' do

    background do
      sign_in(user)
    end

    scenario 'create answer for question' do
      visit question_path(question)
      fill_in 'Body', with: 'Answer body'
      click_on 'Send an answer'
      expect(page).to have_content 'Answer body'
    end

    scenario 'create answer for question with errors' do
      visit question_path(question)
      fill_in 'Body', with: ''
      click_on 'Send an answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user try create answer' do
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Send an answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
