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

  test 'search finds records and paginates' do
    [Question, Answer, Comment, User].each { |model| PgSearch::Multisearch.rebuild(model) }

    get search_path, params: { search: { body: 'Hotwire', scope: 'questions' } }

    assert_response :success
    assert_select '.search-results li', 1
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
end
