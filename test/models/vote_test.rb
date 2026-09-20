# frozen_string_literal: true

require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  test 'score must be between -1 and 1' do
    vote = Vote.new(user: users(:alice), votable: questions(:hotwire), score: 5)
    assert_not vote.valid?
  end

  test 'votable rating sums scores' do
    assert_equal 1, questions(:rails).rating
    questions(:rails).formation_vote(users(:alice), -1)
    assert_equal 0, questions(:rails).rating
  end

  test 'formation_vote updates an existing vote instead of adding another' do
    assert_no_difference -> { Vote.count } do
      questions(:rails).formation_vote(users(:bob), -1)
    end
    assert_equal(-1, questions(:rails).rating)
  end
end
