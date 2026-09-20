# frozen_string_literal: true

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'requires a body of at least 10 characters' do
    comment = Comment.new(commentable: questions(:rails), user: users(:alice), body: 'short')
    assert_not comment.valid?
  end

  test 'question resolves for question and answer comments' do
    assert_equal questions(:rails), comments(:on_question).question
    assert_equal questions(:rails), comments(:on_answer).question
  end

  test 'broadcasts creation to the question stream' do
    assert_turbo_stream_broadcasts(questions(:rails), count: 1) do
      questions(:rails).comments.create!(user: users(:bob), body: 'A brand new comment')
    end
  end
end
