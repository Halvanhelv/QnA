# frozen_string_literal: true

require 'test_helper'

class QuestionsTest < ActionDispatch::IntegrationTest
  test 'index lists questions and subscribes to the questions stream' do
    get root_path

    assert_response :success
    assert_select 'ul#questions li', Question.count
    assert_select 'turbo-cable-stream-source'
  end

  test 'show renders question, answers, comments and new answer form' do
    sign_in users(:bob)
    get question_path(questions(:rails))

    assert_response :success
    assert_select 'h1', questions(:rails).title
    assert_select '#answers > article', questions(:rails).answers.count
    assert_select "ul##{dom_id(questions(:rails), :comments)} li", 1
    assert_select 'form.new-answer'
  end

  test 'show marks owner-only controls for client-side visibility' do
    get question_path(questions(:rails))

    assert_select "[data-controller='visibility'][data-visibility-rule-value='owner'][hidden]"
  end

  test 'guest cannot open the new question form' do
    get new_question_path
    assert_redirected_to new_user_session_path
  end

  test 'signed in user creates a question with a link and a reward' do
    sign_in users(:alice)

    assert_difference -> { Question.count } => 1, -> { Link.count } => 1, -> { Reward.count } => 1 do
      post questions_path, params: { question: {
        title: 'Brand new', body: 'Question body',
        links_attributes: { '1' => { name: 'Docs', url: 'https://example.com' } },
        reward_attributes: { name: 'Trophy', img: fixture_file_upload('reward.png', 'image/png') }
      } }
    end

    assert_redirected_to question_path(Question.last)
  end

  test 'invalid question re-renders the form with 422' do
    sign_in users(:alice)

    assert_no_difference -> { Question.count } do
      post questions_path, params: { question: { title: '', body: '' } }
    end

    assert_response :unprocessable_entity
    assert_select 'ul li', /can't be blank/
  end

  test 'the author updates a question through a turbo frame' do
    sign_in users(:alice)

    get edit_question_path(questions(:rails))
    assert_select "turbo-frame##{dom_id(questions(:rails), :edit)} form"

    patch question_path(questions(:rails)), params: { question: { title: 'Updated title' } }, headers: turbo_headers

    assert_response :success
    assert_equal 'Updated title', questions(:rails).reload.title
    assert_turbo_stream action: 'update', target: 'flash'
  end

  test 'invalid update renders the edit frame with 422' do
    sign_in users(:alice)

    patch question_path(questions(:rails)), params: { question: { title: '' } }

    assert_response :unprocessable_entity
    assert_select "turbo-frame##{dom_id(questions(:rails), :edit)}"
  end

  test "a user cannot update someone else's question" do
    sign_in users(:bob)

    patch question_path(questions(:rails)), params: { question: { title: 'Hacked' } }

    assert_redirected_to root_path
    assert_not_equal 'Hacked', questions(:rails).reload.title
  end

  test 'the author deletes a question' do
    sign_in users(:alice)

    assert_difference -> { Question.count } => -1 do
      delete question_path(questions(:rails))
    end

    assert_redirected_to questions_path
  end

  test "a user cannot delete someone else's question" do
    sign_in users(:bob)

    assert_no_difference -> { Question.count } do
      delete question_path(questions(:rails))
    end
  end

  test 'admin can delete any question' do
    sign_in users(:admin)

    assert_difference -> { Question.count } => -1 do
      delete question_path(questions(:rails))
    end
  end
end
