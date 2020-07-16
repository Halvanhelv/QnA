# frozen_string_literal: true

module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    visit questions_path
    click_on I18n.t('questions.index.question.new_button')
  end

  def create_question(question)
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on I18n.t('helpers.submit.question.create')

    visit question_path(question)
  end

  def create_answer(answer)
    fill_in 'Body', with: answer.body
    click_on I18n.t('helpers.submit.answer.update')
  end
end
