# frozen_string_literal: true

require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  test 'guest cannot open the comment form' do
    get new_question_comment_path(questions(:rails))
    assert_redirected_to new_user_session_path
  end

  test 'renders the comment form inside a turbo frame' do
    sign_in users(:alice)

    get new_answer_comment_path(answers(:step_by_step))

    assert_select "turbo-frame##{dom_id(answers(:step_by_step), :new_comment)} form"
  end

  test 'comments on a question' do
    sign_in users(:alice)
    question = questions(:hotwire)

    assert_difference -> { question.comments.count } => 1 do
      post question_comments_path(question), params: { comment: { body: 'A useful comment' } }, headers: turbo_headers
    end

    assert_turbo_stream action: 'replace', target: dom_id(question, :new_comment)
    assert_equal users(:alice), question.comments.last.user
  end

  test 'comments on an answer and broadcasts to the question stream' do
    sign_in users(:alice)
    answer = answers(:step_by_step)

    assert_turbo_stream_broadcasts(answer.question, count: 1) do
      post answer_comments_path(answer), params: { comment: { body: 'A useful comment' } }, headers: turbo_headers
    end

    assert_equal 1, answer.comments.where(body: 'A useful comment').count
  end

  test 'too short comment re-renders the frame with 422' do
    sign_in users(:alice)

    assert_no_difference -> { Comment.count } do
      post question_comments_path(questions(:rails)), params: { comment: { body: 'short' } }
    end

    assert_response :unprocessable_entity
    assert_select 'turbo-frame li', /too short/
  end
end
