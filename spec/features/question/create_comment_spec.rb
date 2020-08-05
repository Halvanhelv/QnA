require 'rails_helper'

feature 'User can add comment to question.', %q(
"In order to request additional information from question author
 I'd like to be able to add comment."
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment for question' do
      within '#question' do
          click_on 'add comment'
        fill_in 'Body', with: 'This is test comment for question'
        click_on 'save comment'
      end
      expect(page).to have_content 'This is test comment for question'
    end

    scenario 'can not add comment with invalid attributes' do
      within '#question' do
        click_on 'add comment'
        fill_in 'Body', with: ''
        click_on 'save comment'
      end
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Body is too short (minimum is 10 characters)"
    end

  end
  describe 'multiple sessions' do
    scenario "question comment appears on another user's page"

  end

  describe 'Unauthenticated user' do
    scenario 'can not add comment' do
      visit question_path(question)

      expect(page).to_not have_css('#question-comment')
    end
  end
end