# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his answer', "
The user should be able to delete his answer
but not someone else’s
" do
  given(:other_user) { create(:user) }
  given(:answer)     { create(:answer) }

  background do
    sign_in(answer.user)
  end

  describe 'Authenticated user', js: true do

    scenario 'trying to delete his answer' do
      visit question_path(answer.question)
      expect(page).to have_content answer.body
      click_on 'Delete Answer'
      expect(page).to have_content 'Answer successfully deleted.'
      expect(page).not_to have_content answer.body
    end

    scenario 'trying to delete not your answer' do
      click_on 'Log out'
      sign_in(other_user)
      visit question_path(answer.question)
      expect(page).to have_content answer.body
      expect(page).not_to have_content 'Delete Answer'
    end
  end

  scenario 'Unauthenticated user try delete  answer', js: true do
    click_on 'Log out'
    visit question_path(answer.question)
    expect(page).to have_content answer.body
    expect(page).not_to have_content 'Delete Answer'
  end
end
