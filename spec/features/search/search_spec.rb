require 'sphinx_helper'

feature 'Any user can search', "
  In order to find an interesting question, answer, comment, user
  As a user
   I want to be able to search
" do
  given!(:user) { create(:user, email: 'test@gmail.com') }
  given!(:question) { create(:question, title: 'test question text') }
  given!(:answer) { create(:answer, body: 'test answer text') }
  given!(:comment) { create(:comment, commentable: question, user: user, body: 'test comment text') }

  before { visit root_path }

  describe 'valid data in request' do
    scenario 'search in questions', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_body', with: question.title
        select 'questions', from: 'search_scope'
        click_on 'Search'
        within '.search-results' do
          expect(page).to have_content question.title
        end
      end
    end

    scenario 'search in answers', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_body', with: answer.body
        select 'answers', from: 'search_scope'
        click_on 'Search'
        within '.search-results' do
          expect(page).to have_content answer.body
        end
      end
    end

    scenario 'search in comments', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_body', with: comment.body
        select 'comments', from: 'search_scope'
        click_on 'Search'
        within '.search-results' do
          expect(page).to have_content comment.body
        end
      end
    end

    scenario 'search in users', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_body', with: user.email
        select 'users', from: 'search_scope'
        click_on 'Search'
        within '.search-results' do
          expect(page).to have_content user.email
        end
      end
    end
    scenario 'search all', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_body', with: 'test'
        select 'all', from: 'search_scope'
        click_on 'Search'
        within '.search-results' do
          expect(page).to have_content user.email
          expect(page).to have_content answer.body
          expect(page).to have_content comment.body
          expect(page).to have_content user.email
          expect(page).to have_content question.title
        end
      end
    end
  end

  describe 'empty body in request' do
    scenario 'search in questions', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_body', with: ''
        select 'questions', from: 'search_scope'
        click_on 'Search'
        within '.search-results' do
          expect(page).to_not have_content question.title
        end
      end
    end

    scenario 'search in answers', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_body', with: ''
        select 'answers', from: 'search_scope'
        click_on 'Search'
        within '.search-results' do
          expect(page).to_not have_content answer.body
        end
      end
    end

    scenario 'search in comments', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_body', with: ''
        select 'comments', from: 'search_scope'
        click_on 'Search'
        within '.search-results' do
          expect(page).to_not have_content comment.body
        end
      end
    end

    scenario 'search in users', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_body', with: ''
        select 'users', from: 'search_scope'
        click_on 'Search'
        within '.search-results' do
          expect(page).to_not have_content user.email
        end
      end
    end
    scenario 'search all', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_body', with: ''
        select 'all', from: 'search_scope'
        click_on 'Search'
        within '.search-results' do
          expect(page).to_not have_content user.email
          expect(page).to_not have_content answer.body
          expect(page).to_not have_content comment.body
          expect(page).to_not have_content user.email
          expect(page).to_not have_content question.title
        end
      end
    end
  end
end
