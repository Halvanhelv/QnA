# frozen_string_literal: true

require 'test_helper'

class AnswersTest < ActionDispatch::IntegrationTest
  test 'guest cannot answer' do
    assert_no_difference -> { Answer.count } do
      post question_answers_path(questions(:rails)), params: { answer: { body: 'Guest answer' } }
    end
    assert_redirected_to new_user_session_path
  end

  test 'creates an answer and resets the form via turbo stream' do
    sign_in users(:alice)

    assert_difference -> { Answer.count } => 1 do
      post question_answers_path(questions(:rails)), params: { answer: { body: 'A fine answer' } }, headers: turbo_headers
    end

    assert_response :success
    assert_turbo_stream action: 'replace', target: 'new-answer'
    assert_equal users(:alice), Answer.last.user
  end

  test 'created answer is broadcast to the question stream' do
    sign_in users(:alice)

    assert_turbo_stream_broadcasts(questions(:rails), count: 1) do
      post question_answers_path(questions(:rails)), params: { answer: { body: 'A fine answer' } }, headers: turbo_headers
    end
  end

  test 'attaches files and links' do
    sign_in users(:alice)

    post question_answers_path(questions(:rails)), headers: turbo_headers, params: { answer: {
      body: 'Answer with extras',
      files: [fixture_file_upload('reward.png', 'image/png')],
      links_attributes: { '1' => { name: 'Docs', url: 'https://example.com' } }
    } }

    answer = Answer.last
    assert_equal 1, answer.files.count
    assert_equal 1, answer.links.count
  end

  test 'invalid answer responds 422 with the form and errors' do
    sign_in users(:alice)

    assert_no_difference -> { Answer.count } do
      post question_answers_path(questions(:rails)), params: { answer: { body: 'x' } }, headers: turbo_headers
    end

    assert_response :unprocessable_entity
    assert_turbo_stream action: 'replace', target: 'new-answer'
    assert_select 'li', /too short/
  end

  test 'the author edits an answer in a turbo frame and updates it' do
    sign_in users(:bob)
    answer = answers(:step_by_step)

    get edit_answer_path(answer)
    assert_select "turbo-frame##{dom_id(answer, :edit)} form"

    patch answer_path(answer), params: { answer: { body: 'Edited answer' } }, headers: turbo_headers

    assert_equal 'Edited answer', answer.reload.plain_body
    assert_turbo_stream action: 'replace', target: dom_id(answer)
  end

  test 'invalid update re-renders the edit frame' do
    sign_in users(:bob)

    patch answer_path(answers(:step_by_step)), params: { answer: { body: 'x' } }

    assert_response :unprocessable_entity
    assert_select 'turbo-frame'
  end

  test "a user cannot edit someone else's answer" do
    sign_in users(:alice)

    patch answer_path(answers(:step_by_step)), params: { answer: { body: 'Hijacked answer' } }

    assert_not_equal 'Hijacked answer', answers(:step_by_step).reload.plain_body
  end

  test 'the author deletes an answer' do
    sign_in users(:bob)
    answer = answers(:step_by_step)

    assert_difference -> { Answer.count } => -1 do
      delete answer_path(answer), headers: turbo_headers
    end

    assert_turbo_stream action: 'remove', target: dom_id(answer)
  end

  test 'the question author picks the best answer' do
    sign_in users(:alice)
    answer = answers(:step_by_step)

    patch best_answer_answer_path(answer), headers: turbo_headers

    assert answer.reload.best_answer
    assert_turbo_stream action: 'replace', target: 'answers'
  end

  test 'other users cannot pick the best answer' do
    sign_in users(:bob)
    answer = answers(:step_by_step)

    patch best_answer_answer_path(answer), headers: turbo_headers

    assert_not answer.reload.best_answer
    assert_response :forbidden
  end

  test 'attachments can be removed by the owner' do
    sign_in users(:bob)
    answer = answers(:step_by_step)
    answer.files.attach(io: StringIO.new('data'), filename: 'note.txt')
    attachment = answer.files.first

    assert_difference -> { ActiveStorage::Attachment.count } => -1 do
      delete attachment_path(attachment), headers: turbo_headers
    end

    assert_turbo_stream action: 'remove', target: dom_id(attachment)
  end
end
