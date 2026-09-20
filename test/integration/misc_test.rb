# frozen_string_literal: true

require 'test_helper'

class MiscTest < ActionDispatch::IntegrationTest
  test 'health check' do
    get rails_health_check_path
    assert_response :success
  end

  test 'guests cannot see rewards' do
    get rewards_path
    assert_redirected_to new_user_session_path
  end

  test 'rewards page lists the user rewards' do
    reward = questions(:rails).create_reward!(name: 'Trophy', img: fixture_file_upload('reward.png', 'image/png'), user: users(:bob))
    sign_in users(:bob)

    get rewards_path

    assert_response :success
    assert_select 'body', /#{reward.name}/
  end

  test 'search finds records and highlights the match' do
    SearchDocument.rebuild

    get search_path, params: { search: { body: 'Hotwire', scope: 'questions' } }

    assert_response :success
    assert_select '.search-results > li', 1
    assert_select '.search-results mark', /hotwire/i
    assert_select '.search-results a[href=?]', question_path(questions(:hotwire))
  end

  test 'search shows help when nothing is found' do
    SearchDocument.rebuild

    get search_path, params: { search: { body: 'zzzzqqqq', scope: 'questions' } }

    assert_select 'p', 'Nothing found'
    assert_select "a[href*='scope%5D=all'], a[href*='scope]=all']"
  end

  test 'answers and comments link to their place on the question page' do
    SearchDocument.rebuild

    get search_path, params: { search: { body: 'minor', scope: 'answers' } }

    assert_select ".search-results a[href='#{question_path(questions(:rails))}##{dom_id(answers(:step_by_step))}']"
  end

  test 'users are not searchable' do
    SearchDocument.rebuild

    get search_path, params: { search: { body: 'alice', scope: 'users' } }

    assert_response :success
    assert_select '.search-results > li', 0
    assert_no_match(/alice@example.com/, response.body.sub(/<header.*?<\/header>/m, ''))
  end

  test 'search scope select does not offer users' do
    get root_path

    assert_select "select[name='search[scope]'] option", count: 4
    assert_select "select[name='search[scope]'] option[value='users']", 0
  end

  test 'search without params does not fail' do
    get search_path
    assert_response :success
  end

  test 'layout exposes the current user to the visibility controller' do
    sign_in users(:admin)

    get root_path

    assert_select "meta[name='current-user-id'][content='#{users(:admin).id}']"
    assert_select "meta[name='current-user-admin'][content='true']"
  end

  test 'sign in and out' do
    post user_session_path, params: { user: { email: users(:alice).email, password: user_password } }
    assert_redirected_to root_path

    delete destroy_user_session_path
    assert_redirected_to root_path
  end

  test 'invalid sign in responds 422 for turbo' do
    post user_session_path, params: { user: { email: users(:alice).email, password: 'wrong' } }
    assert_response :unprocessable_entity
  end

  test 'jobs dashboard is admin only' do
    sign_in users(:alice)
    get '/jobs'
    assert_response :not_found
  end

  test 'sign up sends a confirmation email' do
    assert_emails 1 do
      post user_registration_path, params: { user: { email: 'new@example.com', password: 'password', password_confirmation: 'password' } }
    end
    assert_redirected_to root_path
  end

  test 'kconv is available for letter_opener in development' do
    assert require('kconv')
  end

  test 'pages set a title and the layout offers a skip link' do
    get question_path(questions(:rails))

    assert_select 'title', "#{questions(:rails).title} - Qna"
    assert_select "a.skip-link[href='#main']"
    assert_select 'main#main'
  end

  test 'signed in users get an ask button in the header' do
    sign_in users(:alice)

    get root_path

    assert_select "header a[href='#{new_question_path}']", /Ask question/
  end
end
