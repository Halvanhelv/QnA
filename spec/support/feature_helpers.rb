# frozen_string_literal: true

module FeatureHelpers
  def sign_in(user)
    user.confirm if user.respond_to?(:confirm)
    login_as(user, scope: :user)
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
