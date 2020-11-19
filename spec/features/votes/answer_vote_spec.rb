# frozen_string_literal: true

require 'rails_helper'
feature 'Users can vote for a answer', "
To assess the value of the answer
As an authorized user
I would like to be able to vote on a answer
" do
  describe 'User', js: true do
    given(:user) { create(:user) }
    given(:user_2) { create(:user) }
    given!(:answer) { create(:answer, user: user) }

    context 'Authenticated user' do
      background { sign_in(user_2) }
      background {  visit question_path(answer.question) }

      scenario 'try vote for the answer' do
        within "#answer-id-#{answer.id}" do
          within '#vote-block' do
            click_on '+'
          end
          within '#vote-rating' do
            expect(page).to have_content '1'
          end
        end

        expect(page).to have_content 'You have successfully voted'
      end

      scenario 'try vote twice on a answer' do
        within "#answer-id-#{answer.id}" do
          within '#vote-block' do
            click_on '+'
            click_on '+'
          end
          expect(page).to have_content '0'
        end
        expect(page).to have_content 'You canceled your vote'
      end

      scenario 'try vote against answer' do
        within "#answer-id-#{answer.id}" do
          within '#vote-block' do
            click_on '-'
          end
        end
        expect(page).to have_content 'You have successfully voted'
      end

      scenario 'try change your vote' do
        within "#answer-id-#{answer.id}" do
          within '#vote-block' do
            click_on '+'
            click_on '-'
          end
        end
        expect(page).to have_content 'You have successfully voted'
      end

      scenario 'try view answer rating' do
        within "#answer-id-#{answer.id}" do
          within '#vote-block' do
            click_on '+'
            within '#vote-rating' do
              expect(page).to have_content '1'
            end
          end
        end
      end

      scenario 'author of the answer try vote for the answer' do
        click_on 'Log out'
        sign_in(user)
        visit question_path(answer.question)
        within "#answer-id-#{answer.id}" do
          within '#vote-block' do
            click_on '+'
          end
        end
        expect(page).to have_content 'You are not authorized to access this page.'
      end
    end
  end
end
