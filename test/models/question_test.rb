# frozen_string_literal: true

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test 'requires title and body' do
    question = Question.new(user: users(:alice))
    assert_not question.valid?
    assert_includes question.errors.attribute_names, :title
    assert_includes question.errors.attribute_names, :body
  end

  test 'subscribes the author on creation' do
    question = Question.create!(title: 'Title', body: 'Body', user: users(:alice))
    assert question.subscribed?(users(:alice))
  end

  test 'accepted_answer returns the accepted answer' do
    question = questions(:rails)
    answer = answers(:step_by_step)
    answer.accept
    assert_equal answer, question.reload.accepted_answer
  end

  test 'ordered_answers puts the accepted answer first' do
    question = questions(:rails)
    second = question.answers.create!(body: 'Another answer', user: users(:alice))
    second.accept
    assert_equal second, question.ordered_answers.first
  end

  test 'destroys dependent records' do
    question = questions(:rails)
    assert_difference -> { Answer.count } => -1, -> { Comment.count } => -2, -> { Subscription.count } => -1 do
      question.destroy
    end
  end

  test 'is added to the multisearch index' do
    question = Question.create!(title: 'Kamal deployment', body: 'How to deploy', user: users(:alice))
    assert_includes PgSearch.multisearch('Kamal').map(&:searchable), question
  end

  test 'creation broadcasts to the questions list' do
    assert_broadcasts('questions', 1) do
      Question.create!(title: 'Fresh', body: 'Body', user: users(:alice))
    end
  end
end
