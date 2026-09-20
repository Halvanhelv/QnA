# frozen_string_literal: true

require 'test_helper'

class ApiV1Test < ActionDispatch::IntegrationTest
  setup do
    @application = Doorkeeper::Application.create!(name: 'test', redirect_uri: 'https://example.com/callback')
  end

  def token_for(user)
    Doorkeeper::AccessToken.create!(application: @application, resource_owner_id: user.id, scopes: 'public').token
  end

  def api_get(path, user: users(:alice))
    get path, params: { access_token: token_for(user) }, headers: { 'ACCEPT' => 'application/json' }
  end

  def api_request(method, path, user: users(:alice), params: {})
    send method, path, params: params.merge(access_token: token_for(user)), headers: { 'ACCEPT' => 'application/json' }
  end

  test 'requires an access token' do
    get api_v1_questions_path, headers: { 'ACCEPT' => 'application/json' }
    assert_response :unauthorized
  end

  test 'profiles/me returns the token owner' do
    api_get me_api_v1_profiles_path

    assert_response :success
    assert_equal users(:alice).email, response.parsed_body.dig('user', 'email')
  end

  test 'profiles lists other users' do
    api_get api_v1_profiles_path

    emails = response.parsed_body['users'].pluck('email')
    assert_not_includes emails, users(:alice).email
    assert_includes emails, users(:bob).email
  end

  test 'questions index includes short titles, users and answers' do
    api_get api_v1_questions_path

    assert_response :success
    question = response.parsed_body['questions'].find { |q| q['id'] == questions(:rails).id }
    assert_equal questions(:rails).title.truncate(7), question['short_title']
    assert_equal questions(:rails).user_id, question['user']['id']
    assert_equal 1, question['answers'].size
  end

  test 'question show includes links and comments' do
    api_get api_v1_question_path(questions(:rails))

    body = response.parsed_body['question']
    assert_equal 1, body['links'].size
    assert_equal 1, body['comments'].size
  end

  test 'creates a question' do
    assert_difference -> { Question.count } => 1 do
      api_request :post, api_v1_questions_path, params: { question: { title: 'API question', body: 'Body' } }
    end
    assert_response :success
    assert_equal users(:alice), Question.last.user
  end

  test 'rejects an invalid question' do
    assert_no_difference -> { Question.count } do
      api_request :post, api_v1_questions_path, params: { question: { title: '', body: '' } }
    end
    assert_response :unprocessable_entity
  end

  test 'updates own question and refuses foreign ones' do
    api_request :patch, api_v1_question_path(questions(:rails)), params: { question: { title: 'Changed title' } }
    assert_response :success
    assert_equal 'Changed title', questions(:rails).reload.title

    api_request :patch, api_v1_question_path(questions(:hotwire)), params: { question: { title: 'Nope nope' } }
    assert_response :forbidden
  end

  test 'destroys own question' do
    assert_difference -> { Question.count } => -1 do
      api_request :delete, api_v1_question_path(questions(:rails))
    end
  end

  test 'answers index, show, create, update, destroy' do
    question = questions(:rails)
    answer = answers(:step_by_step)

    api_get api_v1_question_answers_path(question)
    assert_equal 1, response.parsed_body['answers'].size

    api_get api_v1_answer_path(answer)
    assert_equal answer.body, response.parsed_body.dig('answer', 'body')

    assert_difference -> { question.answers.count } => 1 do
      api_request :post, api_v1_question_answers_path(question), params: { answer: { body: 'API answer body' } }
    end

    api_request :patch, api_v1_answer_path(answer), user: users(:bob), params: { answer: { body: 'Updated by owner' } }
    assert_response :success

    assert_difference -> { Answer.count } => -1 do
      api_request :delete, api_v1_answer_path(answer), user: users(:bob)
    end
  end

  test 'invalid answer is rejected' do
    api_request :post, api_v1_question_answers_path(questions(:rails)), params: { answer: { body: 'x' } }
    assert_response :unprocessable_entity
  end
end
