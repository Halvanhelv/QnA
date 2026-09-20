# frozen_string_literal: true

require 'test_helper'

class VotesTest < ActionDispatch::IntegrationTest
  test 'upvotes a question and updates the rating' do
    sign_in users(:alice)
    question = questions(:hotwire)

    post question_upvote_path(question), headers: turbo_headers

    assert_equal 1, question.rating
    assert_turbo_stream action: 'replace', target: dom_id(question, :votes)
    assert_turbo_stream action: 'update', target: 'my-votes'
    assert_select "[data-vote-rail-score-value='1']"
  end

  test 'voting twice cancels the vote' do
    sign_in users(:alice)
    question = questions(:hotwire)

    2.times { post question_upvote_path(question), headers: turbo_headers }

    assert_equal 0, question.rating
  end

  test 'downvotes an answer' do
    sign_in users(:alice)
    answer = answers(:step_by_step)

    post answer_downvote_path(answer), headers: turbo_headers

    assert_equal(-1, answer.rating)
  end

  test 'the author cannot vote for own resource' do
    sign_in users(:alice)
    question = questions(:rails)

    assert_no_difference -> { Vote.count } do
      post question_upvote_path(question), headers: turbo_headers
    end

    assert_response :forbidden
  end

  test 'guests cannot vote' do
    post question_upvote_path(questions(:hotwire)), headers: turbo_headers
    assert_redirected_to new_user_session_path
  end

  test 'json vote keeps the legacy payload' do
    sign_in users(:alice)

    post question_upvote_path(questions(:hotwire)), headers: { 'Accept' => 'application/json' }

    assert_equal({ 'id' => questions(:hotwire).id, 'type' => 'question', 'rating' => 1,
                   'message' => 'You have successfully voted' }, response.parsed_body)
  end

  test 'question page exposes the signed in user votes for the vote rails' do
    sign_in users(:bob)

    get question_path(questions(:rails))

    votes = JSON.parse(css_select('script#my-votes').first.text)
    assert_equal({ "Question:#{questions(:rails).id}" => 1 }, votes)
  end

  test 'guests get an empty votes map' do
    get question_path(questions(:rails))

    assert_equal({}, JSON.parse(css_select('script#my-votes').first.text))
  end
end
