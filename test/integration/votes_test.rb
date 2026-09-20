# frozen_string_literal: true

require 'test_helper'

class VotesTest < ActionDispatch::IntegrationTest
  test 'upvotes a question and updates the rating' do
    sign_in users(:alice)
    question = questions(:hotwire)

    patch positive_vote_question_path(question), headers: turbo_headers

    assert_equal 1, question.rating
    assert_turbo_stream action: 'update', target: dom_id(question, :rating)
  end

  test 'voting twice cancels the vote' do
    sign_in users(:alice)
    question = questions(:hotwire)

    2.times { patch positive_vote_question_path(question), headers: turbo_headers }

    assert_equal 0, question.rating
  end

  test 'downvotes an answer' do
    sign_in users(:alice)
    answer = answers(:step_by_step)

    patch negative_vote_answer_path(answer), headers: turbo_headers

    assert_equal(-1, answer.rating)
  end

  test 'the author cannot vote for own resource' do
    sign_in users(:alice)
    question = questions(:rails)

    assert_no_difference -> { Vote.count } do
      patch positive_vote_question_path(question), headers: turbo_headers
    end

    assert_response :forbidden
  end

  test 'guests cannot vote' do
    patch positive_vote_question_path(questions(:hotwire)), headers: turbo_headers
    assert_redirected_to new_user_session_path
  end

  test 'json vote keeps the legacy payload' do
    sign_in users(:alice)

    patch positive_vote_question_path(questions(:hotwire)), headers: { 'Accept' => 'application/json' }

    assert_equal({ 'id' => questions(:hotwire).id, 'type' => 'question', 'rating' => 1,
                   'message' => 'You have successfully voted' }, response.parsed_body)
  end
end
