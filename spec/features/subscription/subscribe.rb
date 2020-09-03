require 'rails_helper'

feature 'User can see their rewards', "
  In order to see rewards from users
  As a authenticated user
  I'd like to ba able to see all questions
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'Question owner' do
      within '.new-answer' do
        fill_in 'Body', with: 'Test answer text'
        click_on I18n.t('helpers.submit.answer.create')
      end
    end
  end
end
