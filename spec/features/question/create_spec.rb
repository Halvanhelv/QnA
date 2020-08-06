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

    subject do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'asks a question' do
      subject
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
      subject
      attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
      click_on I18n.t('helpers.submit.question.create')
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with link' do
      subject
      click_on I18n.t('add_link')

      fill_in I18n.t('link_name'), with: 'GIST LINK'
      fill_in I18n.t('link_url'), with: 'https://gist.github.com/SynthesisOne/999ecc10ac745e4f7a3a00ff5b038767'

      click_on I18n.t('helpers.submit.question.create')

      expect(page).to have_link 'GIST LINK'
    end

    scenario 'asks a question with invalid link' do
      subject
      click_on I18n.t('add_link')

      fill_in I18n.t('link_name'), with: 'GIST LINK'
      fill_in I18n.t('link_url'), with: 'INVALID TEXT'

      click_on I18n.t('helpers.submit.question.create')

      expect(page).to have_content 'Links url is invalid'
    end

    scenario 'asks a question with incomplete data for links' do
      subject
      click_on I18n.t('add_link')

      fill_in I18n.t('link_name'), with: 'GIST LINK'
      fill_in I18n.t('link_url'), with: ''

      click_on I18n.t('helpers.submit.question.create')

      expect(page).to have_content "Links url can't be blank"
    end

    scenario 'create question with rewards' do
      subject
      fill_in I18n.t('Reward Name'), with: 'Reward for best answer'
      attach_file I18n.t('Reward Image'), Rails.root.join('spec', 'images', 'reward.png')

      click_on I18n.t('helpers.submit.question.create')

      within '#reward' do
        expect(page).to have_content 'Reward for best answer'
      end
    end

    scenario 'with empty name rewards' do
      subject
      fill_in I18n.t('Reward Name'), with: ''
      attach_file I18n.t('Reward Image'), Rails.root.join('spec', 'images', 'reward.png')

      click_on I18n.t('helpers.submit.question.create')

      expect(page).to have_content "Reward name can't be blank"
    end

    scenario 'with empty image rewards' do
      subject
      fill_in I18n.t('Reward Name'), with: 'Reward Name text'

      click_on I18n.t('helpers.submit.question.create')

      expect(page).to have_content "Reward img can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on I18n.t('questions.index.question.new_button')
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on I18n.t('questions.index.question.new_button')

        fill_in 'Title', with: 'Title of question'
        fill_in 'Body', with: 'Body of question'
        click_on I18n.t('helpers.submit.question.create')

        expect(page).to have_content 'Title of question'
        expect(page).to have_content 'Body of question'
      end
    end
  end
end
