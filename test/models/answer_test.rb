# frozen_string_literal: true

require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test 'requires a body of at least 6 characters' do
    answer = Answer.new(question: questions(:rails), user: users(:alice), body: 'short')
    assert_not answer.valid?

    answer.body = 'long enough'
    assert answer.valid?
  end

  test 'make_best_answer replaces the previous best answer' do
    question = questions(:rails)
    old_best = question.answers.create!(body: 'Old best answer', user: users(:alice), best_answer: true)
    new_best = answers(:step_by_step)

    new_best.make_best_answer

    assert new_best.reload.best_answer
    assert_not old_best.reload.best_answer
  end

  test 'make_best_answer gives the reward to the answer author' do
    question = questions(:rails)
    reward = question.create_reward!(name: 'Trophy', img: Rack::Test::UploadedFile.new(file_fixture('reward.png'), 'image/png'))
    answer = answers(:step_by_step)

    answer.make_best_answer

    assert_equal answer.user, reward.reload.user
  end

  test 'enqueues a notification when the question has subscribers' do
    assert_enqueued_with(job: NewAnswerNotificationJob) do
      Answer.create!(question: questions(:rails), user: users(:bob), body: 'Brand new answer')
    end
  end

  test 'broadcasts creation to the question stream' do
    assert_turbo_stream_broadcasts(questions(:rails), count: 1) do
      Answer.create!(question: questions(:rails), user: users(:bob), body: 'Brand new answer')
    end
  end
end
