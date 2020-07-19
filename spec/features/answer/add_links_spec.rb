require 'rails_helper'

feature 'User can add links to answer', "
In order to provide additional info to my answer
As an answer's author
I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/SynthesisOne/8c1d50f437cc54c9585dc0ae55b12ba4' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      click_on I18n.t('add_link')
      fill_in 'Body', with: 'text text text'
      fill_in I18n.t('link_name'), with: 'My gist'
      fill_in I18n.t('link_url'), with: gist_url
      click_on I18n.t('helpers.submit.answer.create')
    end

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
