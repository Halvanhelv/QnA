# frozen_string_literal: true

module SearchHelper
  # Marks the words of `text` that start like any query word (so "upgrade" is marked for "upgrading")
  def highlight_terms(text, tokens)
    return h(text) if tokens.blank?

    stems = tokens.map { |token| Regexp.escape(token[0, [token.length, 5].min]) }
    pattern = /(?<![\p{L}\p{N}])(?:#{stems.join('|')})[\p{L}\p{N}]*/i
    sanitize(h(text).gsub(pattern) { |word| "<mark>#{word}</mark>" }, tags: %w[mark])
  end

  # Where a search hit points: the question page, at the answer or comment when it is one
  def search_hit_path(record)
    case record
    when Question then question_path(record)
    when Answer then question_path(record.question, anchor: dom_id(record))
    when Comment then question_path(record.question, anchor: dom_id(record))
    end
  end

  def search_hit_question(record)
    record.is_a?(Question) ? record : record.question
  end
end
