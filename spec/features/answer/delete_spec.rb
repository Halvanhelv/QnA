# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his question', "
The user should be able to delete his question
but not someone else’s
" do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { user.questions.create(attributes_for(:question)) }
  given(:answer) { create(:answer, user: user, question: question) }
  background do
    sign_in(user)
    create_question(question)
    create_answer(answer)
  end

  scenario 'User try delete his answer' do
    expect(page).to have_content answer.body
    click_on 'Delete Answer'
    expect(page).to have_content 'Answer successfully deleted.'
  end

end
