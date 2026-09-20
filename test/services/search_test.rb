# frozen_string_literal: true

require 'test_helper'

class SearchServiceTest < ActiveSupport::TestCase
  setup { SearchDocument.rebuild }

  def search(query, scope: 'all', **params)
    Services::Search.new(body: query, scope: scope, **params).tap(&:call)
  end

  def records(query, **options)
    search(query, **options).result.map(&:searchable)
  end

  test 'finds questions, answers and comments' do
    assert_equal [questions(:hotwire)], records('Hotwire', scope: 'questions')
    assert_equal [answers(:step_by_step)], records('minor', scope: 'answers')
    assert_equal [comments(:on_question)], records('Nice', scope: 'comments')
  end

  test 'searches everywhere by default' do
    found = records('Turbo')

    assert_includes found, questions(:hotwire)
    assert_includes found, answers(:use_hotwire)
  end

  test 'matches word forms in English' do
    assert_includes records('upgrading'), questions(:rails)
    assert_includes records('answered'), comments(:on_answer)
  end

  test 'matches word forms in Russian' do
    question = Question.create!(user: users(:alice), title: 'Как обновить приложение?', body: 'Хочу перейти на последнюю версию')

    assert_includes records('обновлению'), question
    assert_includes records('ОБНОВЛЕНИЯ'), question
    assert_includes records('версии'), question
  end

  test 'treats ё like е' do
    question = Question.create!(user: users(:alice), title: 'Всё про ёлки', body: 'Текст')

    assert_includes records('елки'), question
  end

  test 'finds by tag' do
    assert_equal [questions(:hotwire)], records('hotwire', scope: 'questions')
    questions(:rails).update!(tag_list: 'deployment')

    assert_equal [questions(:rails)], records('deployment', scope: 'questions')
  end

  test 'finds by a Cyrillic tag' do
    question = Question.create!(user: users(:alice), title: 'Вопрос', body: 'Текст', tag_list: 'обновление')

    assert_equal [question], records('обновление', scope: 'questions')
  end

  test 'every word has to match' do
    assert_equal [questions(:rails)], records('upgrade latest', scope: 'questions')
    assert_empty records('upgrade hotwire', scope: 'answers')
  end

  test 'when no document has all the words, the closest titles are offered' do
    found = records('upgrade hotwire', scope: 'questions')

    assert_includes found, questions(:rails)
    assert_includes found, questions(:hotwire)
  end

  test 'the last word may be a prefix' do
    assert_includes records('upgr'), questions(:rails)
    assert_equal [questions(:hotwire)], records('hotw', scope: 'questions')
  end

  test 'tolerates typos when nothing matches exactly' do
    assert_equal [questions(:hotwire)], records('hotwrie', scope: 'questions')
  end

  test 'typo tolerance does not widen an exact search' do
    assert_equal [questions(:rails)], records('upgrade latest', scope: 'questions')
  end

  test 'does not match markup or unrelated text' do
    questions(:rails).update!(body: '<div><pre data-language="ruby">puts 1</pre></div>')

    assert_empty records('div', scope: 'questions')
    assert_empty records('language', scope: 'questions')
    assert_includes records('puts', scope: 'questions'), questions(:rails)
  end

  test 'a title match outranks a body match' do
    body_only = Question.create!(user: users(:alice), title: 'Something else', body: 'mentions kamal in passing')
    title_hit = Question.create!(user: users(:alice), title: 'Kamal setup', body: 'unrelated')

    assert_equal [title_hit, body_only], records('kamal', scope: 'questions')
  end

  test 'users are never searchable' do
    assert_empty records('alice')
    assert_empty records('bob@example.com')
  end

  test 'ignores single letters and punctuation' do
    assert_empty records('c++')
    assert_empty records('   ')
    assert_empty records('')
  end

  test 'unknown scope falls back to all' do
    assert_equal 'all', search('x', scope: 'users').scope
    assert_equal 'all', search('x', scope: 'bogus').scope
  end

  test 'snippets mark the matching words' do
    result = search('Turbo')
    document = result.result.find { |doc| doc.searchable == answers(:use_hotwire) }

    assert_includes result.snippets[document.id], '<mark>Turbo</mark>'
  end

  test 'snippets escape user text' do
    answers(:use_hotwire).update!(body: 'Try &lt;script&gt;alert(1)&lt;/script&gt; with Turbo Streams')

    result = search('turbo')
    document = result.result.find { |doc| doc.searchable == answers(:use_hotwire) }

    assert_not_includes result.snippets[document.id], '<script>'
    assert_includes result.snippets[document.id], '<mark>Turbo</mark>'
    assert result.snippets[document.id].html_safe?
  end

  test 'a hostile query cannot break the SQL' do
    assert_nothing_raised { search("'; DROP TABLE questions; -- \\ :* ! & |").result.to_a }
    assert Question.exists?
  end

  test 'paginates' do
    12.times { |i| Question.create!(user: users(:alice), title: "Pagination #{i}", body: 'text') }

    first = search('pagination', scope: 'questions', per_page: 5)
    assert_equal 5, first.result.size
    assert_equal 12, first.result.total_entries
  end
end
