require 'rails_helper'
feature 'User can edit his answer', "
In order to correct mistakes
As an author of answer
I'd like ot be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do

    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'edits his answer' do

      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'
        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    describe 'edits his answer with errors' do

      scenario 'type empty Body' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Body', with: ''
          click_on 'Save'
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Edit'
    end
  end
end
