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

    scenario 'create answer for question', js: true do
      visit question_path(question)
      within '.new-answer' do
        fill_in 'Body', with: 'Answer body'
        attach_file 'Files', Rails.root.join('spec', 'rails_helper.rb')
        click_on I18n.t('helpers.submit.answer.create')
      end
      within '.answers' do
        expect(page).to have_content 'Answer body'
        expect(page).to have_link('rails_helper.rb')
      end
    end

    scenario 'create answer for question with errors', js: true do
      visit question_path(question)
      fill_in 'Body', with: ''
      click_on I18n.t('helpers.submit.answer.create')
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user try create answer' do
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on I18n.t('helpers.submit.answer.create')
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
