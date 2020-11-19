# frozen_string_literal: true

require 'rails_helper'

feature 'User can add comment to answer.', %q(
"In order to request additional information from answer author
 I'd like to be able to add comment."
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment for answer' do
      within '.answers' do
        within "#answer-id-#{answer.id}" do
          click_on I18n.t('add comment')
          within '.comment-block' do
            fill_in 'Body', with: 'Test text for answer comment'
          end

          click_on I18n.t('save comment')
          within '.answer_comments' do
            expect(page).to have_content 'Test text for answer comment'
          end
        end
      end
    end

    scenario 'can not add comment with invalid attributes' do
      within '.answers' do
        within "#answer-id-#{answer.id}" do
          click_on I18n.t('add comment')
          within '.comment-block' do
            fill_in 'Body', with: ''
          end

          click_on I18n.t('save comment')
          within '.answer-errors' do
            expect(page).to have_content 'Body is too short (minimum is 10 characters)'
            expect(page).to have_content "Body can't be blank"
          end
        end
      end
    end
  end

  describe 'multiple sessions', js: true do
    scenario "answer comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      Capybara.using_session('guest') do
        visit question_path(question)
      end
      Capybara.using_session('user') do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            click_on I18n.t('add comment')
            within '.comment-block' do
              fill_in 'Body', with: 'Test text for answer comment'
              click_on I18n.t('save comment')
            end
            expect(page).to have_content 'Test text for answer comment'
          end
        end
      end
      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Test text for answer comment'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not add comment' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content I18n.t('add comment')
      end
    end
  end
end
