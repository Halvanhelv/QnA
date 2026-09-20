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

  test 'is added to the search index with its tags' do
    question = Question.create!(title: 'Kamal deployment', body: 'How to deploy', user: users(:alice), tag_list: 'kamal, servers')

    document = SearchDocument.find_by!(searchable: question)
    assert_equal 'Kamal deployment', document.title
    assert_equal 'How to deploy', document.body
    assert_equal 'kamal, servers', document.tags
  end

  test 'search entry follows edits and disappears with the record' do
    question = questions(:rails)
    question.update!(title: 'Renamed question', body: 'Completely new text')

    document = SearchDocument.find_by!(searchable: question)
    assert_equal 'Renamed question', document.title
    assert_equal 'Completely new text', document.body

    question.destroy
    assert_nil SearchDocument.find_by(searchable_type: 'Question', searchable_id: question.id)
  end

  test 'changing only the tags refreshes the search entry' do
    question = questions(:rails)
    question.update!(tag_list: 'rails, kamal')

    assert_includes SearchDocument.find_by!(searchable: question).tags, 'kamal'
  end

  test 'creation broadcasts to the questions list' do
    assert_broadcasts('questions', 1) do
      Question.create!(title: 'Fresh', body: 'Body', user: users(:alice))
    end
  end
end
