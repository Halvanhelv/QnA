# frozen_string_literal: true

require 'rails_helper'
feature 'User can delete his question', "
The user should be able to delete his question
but not someone else’s
" do
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(question.user)
  end

  describe 'Authenticated user' do
    scenario 'trying to delete his question' do
      visit question_path(question)
      click_on I18n.t('questions.question.delete')
      expect(page).to have_content 'Question successfully deleted.'
    end

    scenario 'trying to delete not your question' do
      click_on 'Log out'
      sign_in(other_user)
      visit question_path(question)
      expect(page).not_to have_content I18n.t('questions.question.delete')
    end
  end

  scenario 'Unauthenticated user try delete question' do
    click_on 'Log out'
    visit question_path(question)
    expect(page).not_to have_content 'Delete'
  end
end
