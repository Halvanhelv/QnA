# frozen_string_literal: true

require 'test_helper'

class SearchServiceTest < ActiveSupport::TestCase
  setup { [Question, Answer, Comment, User].each { |model| PgSearch::Multisearch.rebuild(model) } }

  def search(params)
    Services::Search.new(params).tap(&:call).result
  end

  test 'searches questions' do
    result = search(body: 'Hotwire', scope: 'questions')
    assert_equal [questions(:hotwire)], result.to_a
  end

  test 'searches answers' do
    assert_equal [answers(:step_by_step)], search(body: 'minor', scope: 'answers').to_a
  end

  test 'searches comments' do
    assert_equal [comments(:on_question)], search(body: 'Nice', scope: 'comments').to_a
  end

  test 'searches users' do
    assert_equal [users(:alice)], search(body: 'alice', scope: 'users').to_a
  end

  test 'searches everywhere' do
    records = search(body: 'Turbo', scope: 'all').map(&:searchable)
    assert_includes records, questions(:hotwire)
    assert_includes records, answers(:use_hotwire)
  end

  test 'blank query returns nothing' do
    assert_empty search(body: '  ', scope: 'all')
  end

  test 'unknown scope falls back to all' do
    assert_equal 'all', Services::Search.new(body: 'x', scope: 'bogus').scope
  end
end
