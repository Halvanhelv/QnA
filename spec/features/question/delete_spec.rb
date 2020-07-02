# frozen_string_literal: true

require 'rails_helper'
feature 'User can delete his question', "
The user should be able to delete his question
but not someone else’s
" do
  given(:user)         { create(:user) }
  given(:other_user)   { create(:user) }
  given(:question)     { user.questions.create(attributes_for(:question)) }
  background do
    sign_in(user)
    create_question(question)
  end
  describe 'Authenticated user' do
    scenario 'trying to delete his question' do
      click_on 'Delete'
      expect(page).to have_content 'Question successfully deleted.'
    end

    scenario 'trying to delete not your question' do
      click_on 'Log out'
      sign_in(other_user)
      visit question_path(question)
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Unauthenticated user try delete question' do
    click_on 'Log out'
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end
end
