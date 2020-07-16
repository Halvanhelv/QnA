require 'rails_helper'
feature 'User can edit question',
        " In order to change the question
As a authenticated user
I'd like to ba able to edit the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user ', js: true do

    context 'own answer' do
      background { sign_in(user) }
      background { visit question_path(question) }

      scenario 'edit his question' do

        within '#question' do
          click_on I18n.t('questions.question.edit')

          fill_in 'Body', with: 'edited question body'
          fill_in 'Title', with: 'edited question title'

          click_on I18n.t('helpers.submit.question.update')

          expect(page).not_to have_content question.body
          expect(page).not_to have_content question.title
          expect(page).to have_content 'edited question body'
          expect(page).to have_content 'edited question title'
          expect(page).not_to have_selector 'textarea'
        end
      end

      scenario ' user try edit question with empty Title' do

        within '#question' do
          click_on 'Edit'

          fill_in 'Body', with: ''
          fill_in 'Title', with: 'edited question title'

          click_on I18n.t('helpers.submit.question.update')
          expect(page).to have_content question.body
          expect(page).to have_content question.title

          within '#question-errors' do
            expect(page).to have_content "Body can't be blank"
          end
        end
      end

      scenario ' user try edit question with empty Body' do

        within '#question' do
          click_on  I18n.t('questions.question.edit')

          fill_in 'Body', with: 'edited question body'
          fill_in 'Title', with: ''

          click_on I18n.t('helpers.submit.question.update')
          expect(page).to have_content question.body
          expect(page).to have_content question.title

          within '#question-errors' do
            expect(page).to have_content "Title can't be blank"
          end
        end
      end

      context 'try delete attachment' do
        given!(:question) { create(:question, :with_file, user: user) }

        scenario 'attached file' do

          within '#question' do
            click_on  I18n.t('questions.question.edit')

            within '.attachments' do
              expect(page).to have_content(question.files.first.filename)

              click_on I18n.t('delete_attachment')

              expect(page).to_not have_content(question.files.first.filename)
            end
          end
        end
      end

      context 'can delete current attachment from several' do
        given!(:question) { create(:question, :with_files, user: user) }
        given(:attachment_first) { question.files.first }
        given(:attachment_second) { question.files.last }

        scenario 'attached file' do

          within '#question' do
            click_on 'Edit'

            within '.attachments' do

              expect(page).to have_content(attachment_first.filename)
              expect(page).to have_content(attachment_second.filename)

              within ".attachment-id-#{attachment_first.id}" do
                click_on I18n.t('delete_attachment')
              end

              expect(page).to_not have_content(attachment_first.filename)
              expect(page).to have_content(attachment_second.filename)
            end
          end
        end
      end
    end

    context 'other user' do
      given(:other_user) { create(:user) }

      background { sign_in(other_user) }

      scenario 'edit other user question' do
        visit question_path(question)

        within '#question' do
          expect(page).not_to have_link 'Edit'
        end
      end
    end
  end

  scenario 'Unauthenticated user try edit question ' do
    visit question_path(question)

    within '#question' do
      expect(page).not_to have_link 'Edit'
    end
  end
end
