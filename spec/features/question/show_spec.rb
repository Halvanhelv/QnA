# frozen_string_literal: true

require 'rails_helper'
feature 'User can show questions', "
To see all the questions
As an Unauthenticated user
I would like to be able to select a question
" do
  given(:user)      { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:questions) { create_list(:question, 2, user: user) }
  given!(:answer)   { create(:answer, user: user, question: question) }
  given(:answers)   { create_list(:answer, 2, user: user, question: question) }

  scenario ' Authenticated user try show a questions' do
    sign_in(user)
    visit questions_path
    expect(page).to have_content 'MyTitle'
    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
    # expect(page).to have_content 'Question_title_number2'
    # expect(page).to have_content 'Question_title_number3'
  end

  scenario ' Unauthenticated user try show a questions' do
    visit questions_path
    expect(page).to have_content 'MyTitle'
  end

  scenario 'user try show a question' do
    visit questions_path
    click_on 'MyTitle'
    expect(page).to have_content 'MyTitle'
  end

  scenario 'user try show a question answers' do
    answers
    visit questions_path
    click_on 'MyTitle'
    expect(page).to have_content question.answers.first.body
    expect(page).to have_content question.answers.last.body
  end
end
