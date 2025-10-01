# frozen_string_literal: true

module FeatureHelpers
  def sign_in(user)
    user.confirm if user.respond_to?(:confirm)

    if Capybara.current_driver == Capybara.javascript_driver
      # For JS tests, we need to actually visit the login page and submit the form
      # because JS tests run in a separate server process
      visit new_user_session_path

      within('form') do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_button 'Log in'
      end
    else
      # For non-JS tests, we can use Warden's login_as
      login_as(user, scope: :user)
    end
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
