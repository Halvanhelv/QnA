# frozen_string_literal: true

module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    visit questions_path
    click_on 'Ask question'
  end

  def create_question(question)
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Ask'
  end

  def create_answer(answer)
    fill_in 'Body', with: answer.body
    click_on 'Send an answer'
  end
end
