# frozen_string_literal: true

require 'rails_helper'
feature 'User can create question', "
In order to get answer from a community
As an authenticated user
I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user ', js: true do
    background do
      sign_in(user)
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on I18n.t('helpers.submit.question.create')
      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on I18n.t('helpers.submit.question.create')
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attachments' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
      click_on I18n.t('helpers.submit.question.create')
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with link' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on I18n.t('add_link')

      fill_in 'Link name', with: 'GIST LINK'
      fill_in 'Url', with: 'https://gist.github.com/SynthesisOne/999ecc10ac745e4f7a3a00ff5b038767'

      click_on I18n.t('helpers.submit.question.create')

      expect(page).to have_link 'GIST LINK'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on I18n.t('questions.index.question.new_button')
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
