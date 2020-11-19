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
  given(:answers)   { create_list(:answer, 5, user: user, question: question) }

  scenario ' Auth user try show a questions' do
    sign_in(user)
    questions
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario ' Unauth user try show a questions' do
    visit questions_path
    expect(page).to have_content question.title
  end

  scenario 'user try show a question' do
    visit questions_path
    click_on question.title
    expect(page).to have_content question.title
  end

  scenario 'user try show a question answers' do
    visit questions_path
    click_on answers.first.question.title

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
