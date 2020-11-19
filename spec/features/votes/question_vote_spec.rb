# frozen_string_literal: true

require 'rails_helper'
feature 'Users can vote for a question', "
To assess the value of the question
As an authorized user
I would like to be able to vote on a question
" do
  describe 'User', js: true do
    given(:user) { create(:user) }
    given(:user_2)      { create(:user) }
    given!(:question) { create(:question, user: user) }

    context 'Authenticated user' do
      background { sign_in(user_2) }
      background {  visit question_path(question) }

      scenario 'try vote for the question' do
        within '#question' do
          within '#vote-block' do
            click_on '+'
          end
          within '#vote-rating' do
            expect(page).to have_content '1'
          end
        end

        expect(page).to have_content 'You have successfully voted'
      end

      scenario 'try vote twice on a question' do
        within '#question' do
          within '#vote-block' do
            click_on '+'
            click_on '+'
          end
          expect(page).to have_content '0'
        end
        expect(page).to have_content 'You canceled your vote'
      end

      scenario 'try vote against question' do
        within '#question' do
          within '#vote-block' do
            click_on '-'
          end
        end
        expect(page).to have_content 'You have successfully voted'
      end

      scenario 'try change your vote' do
        within '#question' do
          within '#vote-block' do
            click_on '+'
            click_on '-'
          end
        end
        expect(page).to have_content 'You have successfully voted'
      end

      scenario 'try view question rating' do
        within '#question' do
          within '#vote-block' do
            click_on '+'
            within '#question-rating' do
              expect(page).to have_content '1'
            end
          end
        end
      end

      scenario 'author of the question  try vote for the question' do
        click_on 'Log out'
        sign_in(user)
        visit question_path(question)
        within '#question' do
          within '#vote-block' do
            click_on '+'
            within '#vote-rating' do
              expect(page).to have_content '0'
            end
          end
        end
        expect(page).to have_content 'You are not authorized to access this page.'
      end
    end
  end
end
