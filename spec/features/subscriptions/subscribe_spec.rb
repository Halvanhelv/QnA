require 'rails_helper'

feature 'User can subscribe to the question', "
  In order to see rewards from users
  To see question updates
  I'd like to be able to see all question update
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'subscribe to the question', js: true do
      within '#question' do
        expect(page).to have_button(I18n.t('subscribe'))
        click_on 'Subscribe'
        expect(page).to have_button(I18n.t('unsubscribe'))
      end
    end
  end

  describe 'Guest' do
    it 'try subscribe to the question' do
      visit question_path(question)

      within '#question' do
        expect(page).to_not have_button(I18n.t('subscribe'))
        expect(page).to_not have_button(I18n.t('unsubscribe'))
      end
    end
  end
end
