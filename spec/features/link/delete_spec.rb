# frozen_string_literal: true

require 'rails_helper'
feature 'User can create answer for question', "
To write the answer to the question as an authorized user
I would like to write an answer to the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given!(:question_link) { create(:link, linkable: question) }
  given!(:answer_link) { create(:link, linkable: answer) }
  describe 'DELETE #destroy', js: true do
    before {  sign_in(user) }
    before {  visit question_path(question) }

    context 'Delete question link ' do
      scenario 'question owner try delete link' do
        within '#question' do
          click_on I18n.t('questions.question.edit')

          within '.form-group' do
            within ".link-id-#{question_link.id}" do
              click_on I18n.t('links.link.delete_link')
            end
          end

          click_on I18n.t('helpers.submit.question.update')
        end
        expect(page).to_not have_link question_link.name
      end
    end

    context 'Delete answer link' do
      scenario 'answer owner try delete link' do
        within "#answer-id-#{answer.id}" do
          click_on I18n.t('edit_answer')

          within "#edit-answer-#{answer.id}" do
            within ".link-id-#{answer_link.id}" do
              click_on I18n.t('links.link.delete_link')
            end
          end

          click_on I18n.t('helpers.submit.answer.update')
        end
        expect(page).to_not have_link answer_link.name
      end
    end
  end
end
