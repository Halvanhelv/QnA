# frozen_string_literal: true

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'normalizes a free-form list' do
    assert_equal %w[rails hotwire ruby], Tag.normalize('Rails, hotwire  ruby,, RAILS')
  end

  test 'rejects invalid names' do
    assert_not Tag.new(name: '-bad').valid?
    assert_not Tag.new(name: 'has space').valid?
    assert_not Tag.new(name: 'x' * 31).valid?
    assert Tag.new(name: 'c++').valid?
    assert Tag.new(name: 'node.js').valid?
  end

  test 'popular tags are ordered by usage' do
    tags(:hotwire).update!(taggings_count: 5)
    assert_equal 'hotwire', Tag.popular.first.name
  end
end

class TaggableTest < ActiveSupport::TestCase
  test 'tag_list assigns and creates tags' do
    question = Question.create!(title: 'Tagged', body: 'Body', user: users(:alice), tag_list: 'Rails, kamal')

    assert_equal %w[kamal rails], question.reload.tags.map(&:name).sort
    assert Tag.exists?(name: 'kamal')
    assert_equal 2, tags(:rails).reload.taggings_count
  end

  test 'more than five tags is invalid' do
    question = Question.new(title: 'Tagged', body: 'Body', user: users(:alice), tag_list: 'a, b, c, d, e, f')

    assert_not question.valid?
    assert_includes question.errors[:tag_list].join, 'at most 5'
  end

  test 'an invalid tag name is reported' do
    question = Question.new(title: 'Tagged', body: 'Body', user: users(:alice), tag_list: 'ok, -bad')

    assert_not question.valid?
    assert_includes question.errors[:tag_list].join, '-bad'
  end

  test 'tag_list reads back as text' do
    assert_equal 'rails', questions(:rails).tag_list
  end

  test 'tagged_with keeps the question tags intact' do
    questions(:rails).update!(tag_list: 'rails, hotwire')

    found = Question.with_details.tagged_with('rails').first

    assert_equal %w[hotwire rails], found.tags.map(&:name).sort
  end
end

class QuestionListingTest < ActiveSupport::TestCase
  test 'newest first by default' do
    assert_equal [questions(:hotwire), questions(:rails)].sort_by(&:id).reverse, Question.listing.to_a
  end

  test 'unanswered excludes questions with answers' do
    assert_empty Question.listing(sort: 'unanswered')

    fresh = Question.create!(title: 'No answers', body: 'Body', user: users(:alice))
    assert_equal [fresh], Question.listing(sort: 'unanswered').to_a
  end

  test 'top orders by rating' do
    Vote.create!(user: users(:alice), votable: questions(:hotwire), score: 1)
    Vote.create!(user: users(:admin), votable: questions(:hotwire), score: 1)

    assert_equal questions(:hotwire), Question.listing(sort: 'top').first
  end

  test 'filters by tag' do
    assert_equal [questions(:hotwire)], Question.listing(tag: 'hotwire').to_a
  end
end
