# frozen_string_literal: true

require 'rails_helper'
feature 'User can choose best answer for  question', "
  To help users
  As an authorized user
  I want to choose the best answer
" do
  describe 'User try choose best answer', js: true do

    context 'Authenticated user' do

      given(:user) { create(:user) }

      background { sign_in(user) }

      context 'Question author' do

        given(:question) { create(:question, user: user) }
        given!(:answer) { create(:answer, question: question, user: user) }

        background { visit question_path(question) }

        scenario 'try choose best answer' do

          within '.answers' do
            click_on 'Best'
          end

          within '#best-answer' do
            expect(page).to have_content(answer.body)
          end
        end
        context 'best answer already exist' do

          given(:question) { create(:question, user: user) }
          given!(:answer) { create(:answer, question: question, body: 'Answer one', best_answer: true) }
          given!(:second_answer) { create(:answer, question: question, body: 'Answer two') }

          background { visit question_path(question) }

          scenario 'try change best answer' do
            within '.answers' do

              within '#best-answer' do
                expect(page).to have_content(answer.body)
              end

              expect(page).to have_content(second_answer.body)

              within "#answer-id-#{second_answer.id}" do
                click_on 'Best'
              end

              within '#best-answer' do
                expect(page).to have_content(second_answer.body)
                expect(page).to_not have_content(answer.body)
              end

              expect(page).to have_content(answer.body)
            end
          end
        end
      end
      context 'is not question owner' do

        given(:question) { create(:question) }
        given!(:answer) { create(:answer, question: question) }

        scenario 'can not choose best answer' do
          visit question_path(question)

          within '.answers' do
            expect(page).to_not have_link 'Best'
          end
        end
      end
    end

    context 'Unauthenticated user' do

      given(:question) { create(:question) }
      given!(:answer) { create(:answer, question: question) }

      scenario 'choose best answer' do
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_link 'Best'
        end
      end
    end
  end
end
